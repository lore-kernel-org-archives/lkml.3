Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaBBJuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 04:50:20 -0500
Received: from science.horizon.com ([71.41.210.146]:45384 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751537AbaBBJuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 04:50:18 -0500
Date: 2 Feb 2014 04:50:17 -0500
Message-ID: <20140202095017.32007.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dave@sr71.net
Subject: Re: [PATCH 3/3] Kconfig: organize memory-related config options
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config MMAP_ALLOW_UNINITIALIZED
> +	bool "Allow mmapped anonymous memory to be uninitialized"
> +	depends on EXPERT && !MMU
> +	default n
> +	help
> +	  Normally, and according to the Linux spec, anonymous memory obtained
> +	  from mmap() has it's contents cleared before it is passed to
                          ^^^^

"its", please.

If you really want to make me happy, clarify the CONFIG_SLOB help to
explain what a large system is.  More than 4 CPUs?  More tha 32 GB
of RAM?  E-ATX motherboard?
