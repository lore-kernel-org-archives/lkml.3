Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605Ab3ECNnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:43:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762472Ab3ECNnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:43:39 -0400
Message-ID: <5183BF01.9010805@redhat.com>
Date: Fri, 03 May 2013 09:43:29 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] NOHZ, check to see if tick device is initialized in IRQ
 handling path
References: <1367325415-32283-1-git-send-email-prarit@redhat.com> <alpine.LFD.2.02.1305030054530.2891@ionos> <alpine.LFD.2.02.1305030923300.2886@ionos> <5183AECF.4070709@redhat.com> <alpine.LFD.2.02.1305031451561.2886@ionos>
In-Reply-To: <alpine.LFD.2.02.1305031451561.2886@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/03/2013 09:02 AM, Thomas Gleixner wrote:
> On Fri, 3 May 2013, Prarit Bhargava wrote:
>> Down a cpu and then bring it back up.
> 
> Ahhhh. So the issue is, that we do not clear the per cpu ts->inidle
> and friends when we bring the cpu down.
> 

:)  I'll give this a shot and will update with testing results.

Thanks tglx!

P.
