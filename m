Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab3GVQMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:12:36 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:60202 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932830Ab3GVQMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:12:31 -0400
Message-ID: <1374509549.15242.31.camel@x61.thuisdomein>
Subject: Re: 3.10.1 cpufreq suspend/resume regression still present in 3.10.2
From: Paul Bolle <pebolle@tiscali.nl>
To: Kiko Piris <kernel@pirispons.net>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Date: Mon, 22 Jul 2013 18:12:29 +0200
In-Reply-To: <51ED56FF.9030508@linux.vnet.ibm.com>
References: <20130722151653.GA7213@sacarino.pirispons.net>
	 <1374507247.15242.26.camel@x61.thuisdomein>
	 <20130722155456.GA7836@sacarino.pirispons.net>
	 <51ED56FF.9030508@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Jul 2013 16:12:29.0786 (UTC) FILETIME=[43CC43A0:01CE86F6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kiko,

On Mon, 2013-07-22 at 21:29 +0530, Srivatsa S. Bhat wrote:
> On 07/22/2013 09:24 PM, Kiko Piris wrote: 
> > I saw your message and was going to apply it, but I didn’t fully
> > understand that thread and wasn’t sure exactly what patch I was supposed
> > to try and above what version should I apply it (my “kernel skills” are
> > very very limited).

Perhaps my message was unclear, too terse, whatever. I wouldn't have
minded to clarify my message (ie, "apply path x on top of release y). 

> > If you want me to test any patch, I would be more than happy to do so; I
> > would be grafeful if you told me exactly what patch to apply and above
> > which kernel version. 
> 
> Try applying the two mainline commits that I mentioned in my previous
> mail, on top of 3.10.2 and check if it fixes your problem.

Please try what Srivatsa suggested, as Srivatsa understands this issue
much better than I do!


Paul Bolle

