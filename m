Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab3FLQKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:10:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:44291 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3FLQKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:10:36 -0400
Message-ID: <51B89D78.6010906@linutronix.de>
Date: Wed, 12 Jun 2013 18:10:32 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Philip Avinash <avinashphilip@ti.com>
Subject: Re: [PATCH 2/4] ARM: dts: AM33XX: Add PWMSS device tree nodes
References: <1370526759-31163-1-git-send-email-bigeasy@linutronix.de> <1370526759-31163-3-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1370526759-31163-3-git-send-email-bigeasy@linutronix.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 03:52 PM, Sebastian Andrzej Siewior wrote:
> From: Philip Avinash <avinashphilip@ti.com>
> 
> Add PWMSS device tree nodes in relation with ECAP & EHRPWM DT nodes to
> AM33XX SoC family. Also populates device tree nodes for ECAP & EHRPWM by
> adding necessary properties like pwm-cells, base reg & set disabled as
> status.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Can someone please grab #2 till #4? Paul took just #1 as far as I can
tell.

Sebastian
