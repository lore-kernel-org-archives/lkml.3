Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3IWUHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:07:40 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3853 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab3IWUHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:07:39 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <52409F7D.1020804@broadcom.com>
Date: Mon, 23 Sep 2013 22:07:25 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-Version: 1.0
To: "Fengguang Wu" <fengguang.wu@intel.com>
cc: "Hante Meuleman" <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com
Subject: Re: [brcmfmac] BUG: unable to handle kernel paging request at
 ffffffff82196446
References: <20130902102327.GB14264@localhost>
 <5236CC49.7000206@broadcom.com> <20130923121402.GA12626@localhost>
In-Reply-To: <20130923121402.GA12626@localhost>
X-WSS-ID: 7E5E42741R093781793-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 02:14 PM, Fengguang Wu wrote:
> On Mon, Sep 16, 2013 at 11:15:53AM +0200, Arend van Spriel wrote:
>> On 09/02/2013 12:23 PM, Fengguang Wu wrote:
>>> Greetings,
>>>
>>> I got the below dmesg and the first bad commit is
>>
>> Hi Fengguang,
>>
>> I could not reproduce this issue. Could you retest with the attached
>> patch file applied and let me know if that fixes the problem?
>
> Yeah it fixed the problem: no more oops in 1000 kernel boot tests. Thank you!

Whoa, 1000 boots. Thank you for being so thorough :-)

Regards,
Arend


