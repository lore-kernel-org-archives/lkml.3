Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab3EODH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 23:07:59 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:63774 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab3EODH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 23:07:58 -0400
Message-ID: <5192FC0C.60204@lwfinger.net>
Date: Tue, 14 May 2013 22:07:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 3.10-rc1 build warning on 32-bit ppc associated with commit
 3925f46
References: <5192584C.1060003@lwfinger.net> <1368574433.31689.55.camel@pasglop>
In-Reply-To: <1368574433.31689.55.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 06:33 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2013-05-14 at 10:29 -0500, Larry Finger wrote:
>> Hi,
>>
>> When building 3.10-rc1 on a PowerBook G4, I get the following warning:
>
> Thanks. Should be fixed now, let me know if it's not.

It is now fixed. Thanks for a quick response.

Larry


