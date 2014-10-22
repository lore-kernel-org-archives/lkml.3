Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaJVPcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:32:07 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:48677 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbaJVPcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:32:00 -0400
Date: Wed, 22 Oct 2014 17:31:36 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        adi-buildroot-devel@lists.sourceforge.net, linux390@de.ibm.com,
        linux-alpha@vger.kernel.org, linux-am33-list@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-cris-kernel@axis.com, linux-hexagon@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux@openrisc.net,
        linux-m68k@vger.kernel.org, linux-metag@vger.kernel.org,
        linux-mips@linux-mips.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        sparclinux@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 08/47] kernel: Move pm_power_off to common code
Message-ID: <20141022153136.GA11045@linux-mips.org>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-9-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413864783-3271-9-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 09:12:24PM -0700, Guenter Roeck wrote:

> pm_power_off is defined for all architectures. Move it to common code.
> 
> Have all architectures call do_kernel_power_off instead of pm_power_off.
> Some architectures point pm_power_off to machine_power_off. For those,
> call do_kernel_power_off from machine_power_off instead.
> 
> Acked-by: David Vrabel <david.vrabel@citrix.com>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Hirokazu Takata <takata@linux-m32r.org>
> Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
> Acked-by: Max Filippov <jcmvbkbc@gmail.com>
> Acked-by: Rafael J. Wysocki <rjw@rjwysocki.net>
> Acked-by: Richard Weinberger <richard@nod.at>
> Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Ralf Baechle <ralf@linux-mips.org>
