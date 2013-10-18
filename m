Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab3JRHWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 03:22:49 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1367 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab3JRHWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 03:22:48 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <5260E188.4090206@broadcom.com>
Date: Fri, 18 Oct 2013 09:21:44 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-Version: 1.0
To: "Bob Copeland" <me@bobcopeland.com>,
        "Steven Rostedt" <rostedt@goodmis.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: trace-cmd problem with FC19
References: <525FD328.1040204@broadcom.com>
 <20131017144116.044f3aaf@gandalf.local.home>
 <52604373.5010907@broadcom.com>
 <20131017162029.002485b1@gandalf.local.home>
 <CAEKwDSAucy8NziB=mcem7we9vnGHe=cWt-4Q1X7+Vt5dokY19A@mail.gmail.com>
 <20131017165656.54b8b985@gandalf.local.home>
 <20131017211143.GA29276@localhost>
In-Reply-To: <20131017211143.GA29276@localhost>
X-WSS-ID: 7E7E3E321R0101777893-14-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 11:11 PM, Bob Copeland wrote:
> On Thu, Oct 17, 2013 at 04:56:56PM -0400, Steven Rostedt wrote:
>> Hmm, are you sure?
>>
>> You may want to do both:
>>
>> sudo trace-cmd -v
>> which trace-cmd

Aaargh, bullocks! My home dir is an NFS mount on FC19 x64 machine and it 
has a 32-bit trace-cmd installed in ~/bin. Sorry for the noise.

>> to see which version it is.
>
> To clarify - I ran into the referenced issue using an older,
> self-compiled version with a recent kernel.  The FC19 distro
> version may be fine, for all I know.

Indeed saw your post googling for this error message, which is why I 
cloned trace-cmd repo.

Going to sit in a corner feeling stupid :-(

Regards,
Arend

