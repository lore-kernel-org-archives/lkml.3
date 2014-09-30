Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaI3PyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:54:22 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:56288 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaI3PyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:54:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Rob Herring <robh@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of/pci: add pci_pio_to_address dummy for !CONFIG_OF
Date: Tue, 30 Sep 2014 17:54:16 +0200
Message-ID: <2735967.fhQeZkXvnj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140930154201.GR841@e106497-lin.cambridge.arm.com>
References: <706416181.hbVGLDA3o6@wuerfel> <2033939.5UfzeSiRKs@wuerfel> <20140930154201.GR841@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Y1xo68IBxFeXruzyFcYhF6hLIQczv9/OGXefama2Qwd
 bfOrWYiRSRnsGgnfstB3SCfkPgVA/+pOY+vRhWYfi/Jo3Tfj0g
 1HmprshIcHtZqykiTt7Br9KKrJR/bcxDbEYFzBRJYPm3e3aItU
 xaPwzXpq+JFIlghrT0T1E+JMzugrwWFSoqKDsR0L1wxWj9wA3X
 VfwXqdIN9WfMVi111wc4cIyuJ4AmHOlKRPUtfR6Vw0f1eh05ch
 YyvEwEiYKblToGorq8jcL7kUH136ivaSTu+p2NwivpflqMkfro
 /zIlECTDoVrm7Lx5oaykwln31cIefsmyaB7zKpHKFa3lwCTIxn
 7GnWDvDcUONupbj4maMQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 16:42:02 Liviu Dudau wrote:
> On Tue, Sep 30, 2014 at 04:15:19PM +0100, Arnd Bergmann wrote:
> > On Tuesday 30 September 2014 15:45:06 Liviu Dudau wrote:
> > > 
> > > Acked-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > > 
> > > Is that triggered by shmobile_defconfig?
> > > 
> > > 
> > 
> > No, I only found it using randconfig testing, shmobile enables CONFIG_OF by
> > default.
> 
> Hmm, I was looking at who defines CONFIG_PCI_RCAR_GEN2_PCIE and it's only
> present in shmobile_defconfig, but that one does not select any OF options (other
> than CONFIG_ARM_APPENDED_DTB). So there is no way of triggering this other
> than by randconfig?

It should be easy enough to build a kernel without CONFIG_OF that enables
this driver manually on another platform.

	Arnd
