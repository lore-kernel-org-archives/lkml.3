Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab3KFLfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:35:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:43907 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab3KFLfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:35:03 -0500
Date: Wed, 6 Nov 2013 12:34:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/9] irqchip: add DesignWare APB ICTL interrupt
 controller
In-Reply-To: <1383661723-17956-2-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <alpine.DEB.2.02.1311061233010.23353@ionos.tec.linutronix.de>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com> <1383661723-17956-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013, Sebastian Hesselbarth wrote:

> This adds an irqchip driver and corresponding devicetree binding for the
> secondary interrupt controllers based on Synopsys DesignWare IP dw_apb_ictl.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Reviewed-by: Jisheng Zhang <jszhang@marvell.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
