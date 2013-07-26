Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994Ab3GZWAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:00:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759684Ab3GZWAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:00:44 -0400
Date: Fri, 26 Jul 2013 15:00:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marian Chereji <marian.chereji@freescale.com>
Cc: <linux-kernel@vger.kernel.org>, <sebastian.grigore@freescale.com>,
        Schmitt Richard <b43082@freescale.com>,
        Fleming Andrew <AFLEMING@freescale.com>
Subject: Re: [PATCH] lib: Add CRC64 ECMA module
Message-Id: <20130726150043.67b248c9d5d93c00ed30ebc8@linux-foundation.org>
In-Reply-To: <1373619386-29550-1-git-send-email-marian.chereji@freescale.com>
References: <1373619386-29550-1-git-send-email-marian.chereji@freescale.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jul 2013 11:56:26 +0300 Marian Chereji <marian.chereji@freescale.com> wrote:

> Added implementation of CRC64 ECMA checksum.
> 
> Signed-off-by: Marian Chereji <marian.chereji@freescale.com>
> Reviewed-by: Varvara Andrei-B21317 <andrei.varvara@freescale.com>
> Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
> ---
>  include/linux/crc64_ecma.h |   56 +++++++
>  lib/Kconfig                |    7 +
>  lib/Makefile               |    1 +
>  lib/crc64_ecma.c           |  341 ++++++++++++++++++++++++++++++++++++++++++++

Presumably you have some code which will need this library feature?

What code is that, and what is its status?
