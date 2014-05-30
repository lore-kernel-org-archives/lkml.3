Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbaE3Lp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:45:59 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:39899 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaE3Lp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:45:56 -0400
Message-ID: <53886F6C.7090509@mentor.com>
Date: Fri, 30 May 2014 12:45:48 +0100
From: Jim Baxter <jim_baxter@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] usb: gadget: NCM: RX function support multiple
 NDPs
References: <jim_baxter@mentor.com>	<1401383543-10181-1-git-send-email-jim_baxter@mentor.com>	<1401383543-10181-2-git-send-email-jim_baxter@mentor.com> <87d2ewbejv.fsf@nemi.mork.no>
In-Reply-To: <87d2ewbejv.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 30 May 2014 11:45:51.0093 (UTC) FILETIME=[B4B77250:01CF7BFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/14 19:55, Bjørn Mork wrote:
> Jim Baxter <jim_baxter@mentor.com> writes:
> 
>> The NDP was ignoring the wNextNdpIndex in the NDP which
>> means that NTBs containing multiple NDPs would have missed
>> frames.
> 
> Well, just for the record: I believe this field was meant to be reserved
> and always 0 in the CDC NCM spec.  Table 3-3, describing 16bit NDPs,
> says so.  But reading the spec now, I noticed that there is an
> inconsistency between table 3-3 and table 3-4 describing 32bit NDPs.  It
> looks like the field is not reserved in the 32bit version.
> 
> I am pretty sure that is a specification error, but I guess it doesn't
> harm to implement the support anyway.  And it paves the way for an MBIM
> gadget :-)
> 
> 
> 
> 
> Bjørn
> 

Yes I was looking at Figure 3-1, Figure 3-2 which all state it is a
link. I must have been reading Table 3-4.

I am glad to see it helps with the MBIM specification :-) .

Jim


