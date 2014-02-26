Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaBZT6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:58:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:63535 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBZT6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:58:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, Russell King <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>, Ben Dooks <ben-linux@fluff.org>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: Re: DMABOUNCE in pci-rcar
Date: Wed, 26 Feb 2014 20:57:26 +0100
Message-ID: <5165962.7bqj51B15Z@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAErSpo5RV=w+DkgHSZZPOFGiEBBxMSraLV3TepYUZwDJuV+Jzg@mail.gmail.com>
References: <201402241200.21944.arnd@arndb.de> <CAErSpo5RV=w+DkgHSZZPOFGiEBBxMSraLV3TepYUZwDJuV+Jzg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7uKBsBHbX8cIJCl15KsvUyyOcHjDsvdJH9H8xIL5ZgB
 yxh5gcAnz9BCiWpnb9A0vHZoAWhMonAWCUqjz5VnKHNpoCP6og
 KCgMiN5NqofeAZxKhrNNiPYiyo3W06O9Kx5YxkWAIOrLi6tSne
 bPEV8cMDY1eehrZN+GmoE0kW89OKgiN46nb1unWocRHwO8nrXc
 cn5pnyC3bqN8iUM7AbIl+WyuxClZvSlVSKxSR4jjbfy2BMialZ
 MtjTdIB+QYU9wK0H9kKVdPP00vjeD9X6kK/9jKvxcnjMGch04E
 KLkOOtyIZ7aPSbHR4xqHVV9KU8baP/lGjNHn4Jb4SSmrM4DnUH
 Se3TUsaQmb6wrLEvr8qU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014 12:48:17 Bjorn Helgaas wrote:
> On Mon, Feb 24, 2014 at 4:00 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > Hi Magnus,
> >
> > I noticed during randconfig testing that you enabled DMABOUNCE for the
> > pci-rcar-gen2 driver as posted in this patch https://lkml.org/lkml/2014/2/5/30
> >
> > I didn't see the original post unfortunately, but I fear we have to
> > revert it and come up with a better solution, ...
> 
> Sounds like I should drop the following patches from my pci/host-rcar
> branch for now?
> 
>   PCI: rcar: Add DMABOUNCE support
>   PCI: rcar: Enable BOUNCE in case of HIGHMEM
>   PCI: rcar: Make the Kconfig dependencies more generic

Sounds good to me. The last patch is actually fine, but you'll have to
fix the context to apply it without the other two.

	Arnd
