Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab3GVQDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:03:38 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:46504 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab3GVQDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:03:36 -0400
Message-ID: <51ED56FF.9030508@linux.vnet.ibm.com>
Date: Mon, 22 Jul 2013 21:29:59 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Kiko Piris <kernel@pirispons.net>, Paul Bolle <pebolle@tiscali.nl>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: 3.10.1 cpufreq suspend/resume regression still present in 3.10.2
References: <20130722151653.GA7213@sacarino.pirispons.net> <1374507247.15242.26.camel@x61.thuisdomein> <20130722155456.GA7836@sacarino.pirispons.net>
In-Reply-To: <20130722155456.GA7836@sacarino.pirispons.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072215-8878-0000-0000-0000080FEEFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 09:24 PM, Kiko Piris wrote:
> On 22/07/2013 at 17:34 +0200, Paul Bolle wrote:
> 
>> Note that I already suggested to Kiko to try that patch (see
>> https://lkml.org/lkml/2013/7/14/35 ). I don't know whether Kiko tried
>> it, as I never received a reply to my suggestion. So, for now, I can
>> only say that that patch will probably fix the issue.
> 
> Hi,
> 
> Aww! :(
> 
> I saw your message and was going to apply it, but I didn’t fully
> understand that thread and wasn’t sure exactly what patch I was supposed
> to try and above what version should I apply it (my “kernel skills” are
> very very limited).
> 
> Then I just went back to 3.10.0 and forgot about it (until I saw the
> 3.10.2 release announcement). Sorry about that!
> 
> If you want me to test any patch, I would be more than happy to do so; I
> would be grafeful if you told me exactly what patch to apply and above
> which kernel version.
> 

Try applying the two mainline commits that I mentioned in my previous
mail, on top of 3.10.2 and check if it fixes your problem.

Regards,
Srivatsa S. Bhat

