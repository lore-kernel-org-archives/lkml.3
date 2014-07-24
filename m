Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934974AbaGXJ6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:58:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:49522 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838AbaGXJ6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:58:07 -0400
Date: Thu, 24 Jul 2014 11:57:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eli Cohen <eli@mellanox.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:timers/core] net: mlx5: Use ktime_get_ns()
In-Reply-To: <CFE9BFE80FFE4D4892AA5D31387E310FDC6B0D49@MTLDAG01.mtl.com>
Message-ID: <alpine.DEB.2.10.1407241157200.23352@nanos>
References: <tip-14a7004671246d1b799f545335995a9897de1268@git.kernel.org> <CFE9BFE80FFE4D4892AA5D31387E310FDC6B0D49@MTLDAG01.mtl.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 24 Jul 2014, Eli Cohen wrote:

> >> net: mlx5: Use ktime_get_ns()
> 
> I can't find this function in any of the header files under include directory of the kernel source tree. Can you tell where you find it?
> 

It's new and part of the patch series which just got queued in tip
timers/core

Thanks,

	tglx

