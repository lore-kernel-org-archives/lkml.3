Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaIZJPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:15:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:59260 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714AbaIZJPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:15:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcel Ziswiler <marcel@ziswiler.com>
Subject: Re: [PATCH v3 1/2] ARM: dts: vf610-colibri: Add PWM support
Date: Fri, 26 Sep 2014 08:54:35 +0000 (UTC)
Message-ID: <loom.20140926T105322-359@post.gmane.org>
References: <cover.1411378369.git.bhuvanchandra.dv@toradex.com> <d508a6ad39e07d5489c4b5110784902ab0241c44.1411378369.git.bhuvanchandra.dv@toradex.com> <20140926022232.GI21077@dragon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 85.5.191.190 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Guo <shawn.guo <at> freescale.com> writes:

> I was trying to apply the patches, but found pwm1 is not available in
> vf610.dtsi at all.  What tree is your patch generated against?  Or did I
> miss any prerequisite patches?

Yes, I guess for some reason he dropped that one from v3:

http://article.gmane.org/gmane.linux.ports.arm.kernel/357293

