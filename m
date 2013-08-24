Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3HYAKG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 20:10:06 -0400
Received: from plane.gmane.org ([80.91.229.3]:57407 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab3HYAKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 20:10:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Michael Gilbert <mgilbert@debian.org>
Subject: Re: [PATCH] timekeeping: handle epoch roll-over (2038) on 32-bit systems
Date: Sat, 24 Aug 2013 23:47:32 +0000 (UTC)
Message-ID: <loom.20130825T005015-983@post.gmane.org>
References: <CAFaRD2FP0rrQstV1GszP_URO+cZZuQdyRxOYUEmA+5BvopUAvQ@mail.gmail.com> <alpine.LFD.2.02.1306031622520.2905@ionos> <51ACE8AE.2090809@linaro.org> <alpine.LFD.2.02.1306072308040.24812@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 108.248.22.61 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner writes:
> That time value should be 64bit, also people might argue, that we are
> creating a new issue for the year 2554, i.e 541 years from now. I
> don't think we need to worry about that really. We have to leave our
> grand-grand-grand..grandchildren (~20 generations from now) a few
> unsolved problems!

Or at the measly cost of 8 additional bytes, solve the problem well and good 
for the entirety of the human race :)

128 (unsigned) bits defers the rollover problem for 1e-9*(2**128)/3600/24/365 
= 1e22 years, or 770 billion times longer than the current age of the 
universe.

That of course hedges on a 128-bit integer C standard within the next 25 
years ;)

Best wishes,
Mike

