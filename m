Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab3KLXjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:39:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319Ab3KLXi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:38:59 -0500
Message-ID: <1384299531.24631.14.camel@deneb.redhat.com>
Subject: Re: [PATCH RFC 16/17] c6x: Convert from _fdt_start to __dtb_start
From: Mark Salter <msalter@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aurelien Jacquiot <a-jacquiot@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-c6x-dev@linux-c6x.org,
        devicetree@vger.kernel.org
Date: Tue, 12 Nov 2013 18:38:51 -0500
In-Reply-To: <1384285347-13506-17-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
	 <1384285347-13506-17-git-send-email-geert@linux-m68k.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 20:42 +0100, Geert Uytterhoeven wrote:
> Kill the c6x-specific __fdt_blob section, and start
> using .dtb.init.rodata
> from <asm-generic/sections.h> for built-in DTBs, like most other DT
> enabled
> architectures.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: linux-c6x-dev@linux-c6x.org
> Cc: devicetree@vger.kernel.org
> ---
> Untested due to lack of cross-compiler, but the changes are similar to
> microblaze.
> 
> QUESTION: The padding of the DTB is gone, is this OK?

Yes, that's fine.

Acked-by: Mark Salter <msalter@redhat.com>


