Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab3GVQmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:42:00 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41542 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab3GVQl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:41:58 -0400
Message-ID: <51ED5FFD.1070300@linux.vnet.ibm.com>
Date: Mon, 22 Jul 2013 22:08:21 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Kiko Piris <kernel@pirispons.net>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: 3.10.1 cpufreq suspend/resume regression still present in 3.10.2
References: <20130722151653.GA7213@sacarino.pirispons.net> <1374507247.15242.26.camel@x61.thuisdomein> <20130722155456.GA7836@sacarino.pirispons.net> <51ED56FF.9030508@linux.vnet.ibm.com> <1374509549.15242.31.camel@x61.thuisdomein>
In-Reply-To: <1374509549.15242.31.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072216-9574-0000-0000-000008D45F81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 09:42 PM, Paul Bolle wrote:
> Kiko,
> 
> On Mon, 2013-07-22 at 21:29 +0530, Srivatsa S. Bhat wrote:
>> On 07/22/2013 09:24 PM, Kiko Piris wrote: 
>>> I saw your message and was going to apply it, but I didn’t fully
>>> understand that thread and wasn’t sure exactly what patch I was supposed
>>> to try and above what version should I apply it (my “kernel skills” are
>>> very very limited).
> 
> Perhaps my message was unclear, too terse, whatever. I wouldn't have
> minded to clarify my message (ie, "apply path x on top of release y). 
> 
>>> If you want me to test any patch, I would be more than happy to do so; I
>>> would be grafeful if you told me exactly what patch to apply and above
>>> which kernel version. 
>>
>> Try applying the two mainline commits that I mentioned in my previous
>> mail, on top of 3.10.2 and check if it fixes your problem.
> 
> Please try what Srivatsa suggested, as Srivatsa understands this issue
> much better than I do!
> 

Nevertheless, thank you very much for following up on the bug-reports
and suggesting to apply the right fixes. I'm really grateful for that! :-)

Regards,
Srivatsa S. Bhat

