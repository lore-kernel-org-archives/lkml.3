Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab3C3Qih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 12:38:37 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58008 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab3C3Qig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 12:38:36 -0400
MIME-Version: 1.0
In-Reply-To: <1772625.se04ulK18U@vostro.rjw.lan>
References: <1772625.se04ulK18U@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 30 Mar 2013 10:38:15 -0600
Message-ID: <CAErSpo5SFeUJz+w6WWjgU0FQt4VBWXAbsH1b68yzF4y-4Q+siQ@mail.gmail.com>
Subject: Re: PNP: List Rafael Wysocki as a maintainer
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 3:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The Adam Belay's e-mail address in MAINTAINERS under PNP SUPPORT
> is not valid any more and I started to maintain that code in the
> meantime as a matter of fact, so list myself as a maintainer of it
> along with Bjorn and remove the Adam's entry from it.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I poked around a bit and it looks like Adam is in the Stanford Ph.D.
program, but I couldn't find a newer email address for him.

> ---
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-pm/MAINTAINERS
> ===================================================================
> --- linux-pm.orig/MAINTAINERS
> +++ linux-pm/MAINTAINERS
> @@ -6209,7 +6209,7 @@ F:        include/linux/power_supply.h
>  F:     drivers/power/
>
>  PNP SUPPORT
> -M:     Adam Belay <abelay@mit.edu>
> +M:     Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>  M:     Bjorn Helgaas <bhelgaas@google.com>
>  S:     Maintained
>  F:     drivers/pnp/
>
