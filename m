Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaJAO7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:59:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35627 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbaJAO7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:59:31 -0400
Date: Wed, 1 Oct 2014 16:59:27 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 00/11] drm: add support for Atmel HLCDC Display
 Controller
Message-ID: <20141001165927.4fc3ab63@bbrezillon>
In-Reply-To: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Oct 2014 16:52:57 +0200
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> Hello,
> 
> This series is being sent for several weeks now and I wonder if I shouldn't
> split it in several pieces:
> 1) the MFD driver + its DT doc
> 2) the PWM driver + its DT doc
> 3) the DRM/KMS driver + its DT doc
> 4) support for sama5d3 SoCs/boards
> 
> The first reason for doing this is that Lee already accepted the MFD part,
> and I'm pretty sure he'd like me to stop sending him each new version of this
> series.
> The second reason being that smaller series are more likely to be reviewed by
> subsystem maintainers :-).
> 
> Lee, if you still agree with this version, could you take the MTD part (other

                                                     I meant MFD ^

> drivers in this series depend on it).




-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
