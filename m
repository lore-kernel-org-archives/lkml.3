Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab3EGJiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:38:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759548Ab3EGJiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:38:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1367918426-7076-1-git-send-email-geert@linux-m68k.org>
References: <1367918426-7076-1-git-send-email-geert@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: Use PDE attribute setting accessor functions
Date: Tue, 07 May 2013 10:37:30 +0100
Message-ID: <23761.1367919450@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> arch/arm/mach-msm/last_radio_log.c: In function 'msm_init_last_radio_log':
> arch/arm/mach-msm/last_radio_log.c:69:7: error: dereferencing pointer to incomplete type
> 
> arch/cris/kernel/profile.c: In function 'init_cris_profile':
> arch/cris/kernel/profile.c:79:8: error: dereferencing pointer to incomplete type
> 
> Use proc_set_size(), cfr. commit 271a15eabe094538d958dc68ccfc9c36b699247a
> ("proc: Supply PDE attribute setting accessor functions")
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: David Howells <dhowells@redhat.com>
