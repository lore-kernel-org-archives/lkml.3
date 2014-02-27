Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaB0J5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:57:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:51279 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaB0J50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:57:26 -0500
Date: Thu, 27 Feb 2014 10:57:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexandre Bounine <alexandre.bounine@idt.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Xiaotian Feng <xtfeng@gmail.com>, Mike Galbraith <bitbucket@online.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] rapidio/tsi721: fix tasklet termination in dma channel
 release
In-Reply-To: <1393427627-18525-1-git-send-email-alexandre.bounine@idt.com>
Message-ID: <alpine.DEB.2.02.1402271056450.4174@ionos.tec.linutronix.de>
References: <1393427627-18525-1-git-send-email-alexandre.bounine@idt.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014, Alexandre Bounine wrote:

> This patch is a modification of the patch originally proposed
> by Xiaotian Feng <xtfeng@gmail.com>: https://lkml.org/lkml/2012/11/5/413
> This new version disables DMA channel interrupts and ensures that the tasklet
> wil not be scheduled again before calling tasklet_kill().

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
