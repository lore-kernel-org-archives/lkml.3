Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbbAWQLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:11:22 -0500
Received: from www.linutronix.de ([62.245.132.108]:37481 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbAWQLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:11:17 -0500
Date: Fri, 23 Jan 2015 17:10:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 2/8] irqchip: Supply new driver for STi based
 devices
In-Reply-To: <1421920133-7914-3-git-send-email-lee.jones@linaro.org>
Message-ID: <alpine.DEB.2.11.1501231702280.5526@nanos>
References: <1421920133-7914-1-git-send-email-lee.jones@linaro.org> <1421920133-7914-3-git-send-email-lee.jones@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Lee Jones wrote:

> This driver is used to enable System Configuration Register controlled
> External, CTI (Core Sight), PMU (Performance Management), and PL310 L2
> Cache IRQs prior to use.

I'm wondering how this is related to irq_chip, but well, I don't mind
it being parked here.

Though I really cannot say anything about this DT translation
machinery for a single sysconfig register, other than it looks
completely overengineered to me.

The only technical comment I have is: shouldn't all the stuff except
the resume function be marked __init or is any of this required post
init?

Thanks,

	tglx
