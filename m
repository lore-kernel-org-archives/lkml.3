Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbbAXT2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 14:28:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:41107 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbbAXT2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 14:28:36 -0500
Date: Sat, 24 Jan 2015 20:28:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Resend Patch v4 00/16] Kill SMP single function call
 interrupt
In-Reply-To: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1501242027090.5526@nanos>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Jiang Liu wrote:

>  38 files changed, 65 insertions(+), 268 deletions(-)

Nice cleanup. If nobody yells, I'm going to route it through tip.

Thanks,

	tglx
