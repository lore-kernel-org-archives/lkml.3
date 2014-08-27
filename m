Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935743AbaH0Soj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:44:39 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57326 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812AbaH0Soh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:44:37 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Nishanth Menon <nm@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH 02/10] ARM: OMAP5 / DRA7: PM: Set MPUSS-EMIF clock-domain static dependency
Organization: Deep Root Systems, LLC
References: <1408716154-26101-1-git-send-email-nm@ti.com>
	<1408716154-26101-3-git-send-email-nm@ti.com>
Date: Wed, 27 Aug 2014 11:44:34 -0700
In-Reply-To: <1408716154-26101-3-git-send-email-nm@ti.com> (Nishanth Menon's
	message of "Fri, 22 Aug 2014 09:02:26 -0500")
Message-ID: <7hmwapdb71.fsf@paris.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
>
> With EMIF clock-domain put under hardware supervised control, memory
> corruption and untraceable crashes are observed on OMAP5. Further
> investigation revealed that there is a weakness in the PRCM on this
> specific dynamic depedency.

hmm, "weakness".  That's a rather polite way of saying bug. :)

Kevin
