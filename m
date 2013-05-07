Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab3EGPbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:31:38 -0400
Received: from ra.se.axis.com ([195.60.68.13]:42057 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab3EGPbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:31:37 -0400
Date: Tue, 7 May 2013 17:31:31 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] proc: Use PDE attribute setting accessor functions
Message-ID: <20130507153131.GP8853@axis.com>
References: <1367918426-7076-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367918426-7076-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 11:20:26AM +0200, Geert Uytterhoeven wrote:
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

For the CRIS-part:

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
