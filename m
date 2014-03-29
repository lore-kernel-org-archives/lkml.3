Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaC2JGp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 05:06:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40257 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751186AbaC2JGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 05:06:42 -0400
Date: Sat, 29 Mar 2014 10:06:39 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 03/10] ARM: at91: introduce OLD_IRQ_AT91 Kconfig
 option
Message-ID: <20140329100639.5ea454bc@skate>
In-Reply-To: <1396029548-10928-4-git-send-email-b.brezillon.dev@gmail.com>
References: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
	<1396029548-10928-4-git-send-email-b.brezillon.dev@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Boris BREZILLON,

On Fri, 28 Mar 2014 18:59:01 +0100, Boris BREZILLON wrote:

> +config OLD_IRQ_AT91
> +	bool
> +	default false

I don't think "default false" is a valid Kconfig construct. It could be
"default n", but that's useless since "default n" is the default
behavior. So I believe you can simply get rid of that line.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
