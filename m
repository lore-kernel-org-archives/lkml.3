Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaAPSOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:14:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47022 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaAPSOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:14:05 -0500
Message-ID: <52D82169.2000107@canonical.com>
Date: Thu, 16 Jan 2014 13:14:01 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [v3.11][v3.12][v3.13][Regression] EISA: Initialize device before
 its resources
References: <52D81C92.9050800@canonical.com> <CAErSpo64e52Vv8bJ54cPcpnZ=OHMaxt2-D6dA4HCrrLnKo1n7g@mail.gmail.com>
In-Reply-To: <CAErSpo64e52Vv8bJ54cPcpnZ=OHMaxt2-D6dA4HCrrLnKo1n7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 01:12 PM, Bjorn Helgaas wrote:
> On Thu, Jan 16, 2014 at 10:53 AM, Joseph Salisbury
> <joseph.salisbury@canonical.com> wrote:
>> Hi Bjorn,
>>
>> A kernel bug was opened against Ubuntu [0].  After a kernel bisect, it
>> was found the following commit introduced this bug:
> Sorry about that, and thanks for the report.  Did you mean to include
> URL for the bug?
Yes, sorry about that:
http://pad.lv/1251816

>
>> commit 26abfeed4341872364386c6a52b9acef8c81a81a
>> Author: Bjorn Helgaas <bhelgaas@google.com>
>> Date: Mon Apr 15 14:34:02 2013 -0600
>>
>>     EISA: Initialize device before its resources
>>
>> The regression was introduced as of v3.10-rc1.
>>
>> Reverting this commit has resolved the bug.  I wanted to get your
>> feedback, since you are the patch author.  Should we consider reverting
>> this commit in mainline and the stable trees?
>>
>> Thanks,
>>
>> Joe
>>

