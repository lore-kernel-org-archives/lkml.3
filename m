Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbbAXLqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 06:46:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:40235 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbbAXLqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 06:46:46 -0500
Date: Sat, 24 Jan 2015 12:46:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 1/8] dt: bindings: Supply shared ST IRQ
 defines
In-Reply-To: <20150123163938.GC11745@x1>
Message-ID: <alpine.DEB.2.11.1501241244430.5526@nanos>
References: <1421920133-7914-1-git-send-email-lee.jones@linaro.org> <1421920133-7914-2-git-send-email-lee.jones@linaro.org> <alpine.DEB.2.11.1501231656310.5526@nanos> <20150123163938.GC11745@x1>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Lee Jones wrote:
> On Fri, 23 Jan 2015, Thomas Gleixner wrote:
> > Can we please stop adding these pointless filenames all over the
> > place? They are useless and wrong in a lot of cases.
> 
> Less of a copy and paste and more and a `mv` without fixing up the
> file names.  I guess they are silly, but they are rife, so someone must
> think they're a good idea. :)

I'd rather say they are ripe for being banned :)

Thanks,

	tglx
