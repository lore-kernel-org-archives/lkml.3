Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbbAVLY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:24:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:59252 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbAVLYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:24:51 -0500
Date: Thu, 22 Jan 2015 12:24:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, dvhart@infradead.org,
        andy.shevchenko@gmail.com, boon.leong.ong@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark
 X1000
In-Reply-To: <1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie>
Message-ID: <alpine.DEB.2.11.1501221220530.5526@nanos>
References: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie> <1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Bryan O'Donoghue wrote:
>  arch/x86/Kconfig           |  25 ++
>  arch/x86/Kconfig.debug     |  13 +
>  arch/x86/include/asm/imr.h |  60 ++++
>  arch/x86/kernel/Makefile   |   1 +
>  arch/x86/kernel/imr.c      | 681 +++++++++++++++++++++++++++++++++++++++++++++

Can we please stop to dump random stuff into x86/kernel?

x86/platform ... would be a proper place for this.

Thanks,

	tglx
