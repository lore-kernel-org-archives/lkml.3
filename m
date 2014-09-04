Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbaIDIgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:36:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:50249 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026AbaIDIgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:36:36 -0400
Date: Thu, 4 Sep 2014 10:36:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
cc: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/5] Clocksource: Flextimer: Use Macro for clock source
 selection.
In-Reply-To: <0d12608f04674dcc8138bb23431c8ca4@BY2PR0301MB0613.namprd03.prod.outlook.com>
Message-ID: <alpine.DEB.2.10.1409041035450.3333@nanos>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com> <1409031951-39021-6-git-send-email-Li.Xiubo@freescale.com> <alpine.DEB.2.10.1409031346220.3333@nanos> <0d12608f04674dcc8138bb23431c8ca4@BY2PR0301MB0613.namprd03.prod.outlook.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014, Li.Xiubo@freescale.com wrote:
> > So you remove the FTM_SC_PS_MASK without mentioning it in the
> > changelog. Either this is by mistake or it wants to be documented WHY
> > it is not needed in the first place.
> > 
> 
> This is just prepare for the other new features in the future.

So split it into a separate patch and provide a proper changelog WHY
you remove it.

Thanks,

	tglx
