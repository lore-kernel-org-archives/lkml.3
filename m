Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030518AbaGRQoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:44:14 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50774 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756865AbaGRQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:44:07 -0400
X-Sasl-enc: K0ewJdu6/GdZugJhfMaVsREYxgf/5MPe1vpqc2hPjrdS 1405701844
Date: Fri, 18 Jul 2014 09:43:40 -0700
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Benoit Taine <benoit.taine@lip6.fr>, linux-mips@linux-mips.org,
        linux-fbdev@vger.kernel.org, linux-pci@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, linux-acenic@sunsite.dk,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        ath10k@lists.infradead.org, linux-hippi@sunsite.dk,
        industrypack-devel@lists.sourceforge.net, linux-mmc@vger.kernel.org,
        MPT-FusionLinux.pdl@avagotech.com,
        virtualization@lists.linux-foundation.org,
        ath9k-devel@venema.h4ckr.net, wil6210@qca.qualcomm.com,
        linux-pcmcia@lists.infradead.org, linux-can@vger.kernel.org,
        xen-devel@lists.xenproject.org, platform-driver-x86@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, e1000-devel@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH 0/25] Replace DEFINE_PCI_DEVICE_TABLE macro use
Message-ID: <20140718164340.GA24960@kroah.com>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
 <20140718162213.GC31114@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718162213.GC31114@tuxdriver.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 12:22:13PM -0400, John W. Linville wrote:
> On Fri, Jul 18, 2014 at 05:26:47PM +0200, Benoit Taine wrote:
> > We should prefer `const struct pci_device_id` over
> > `DEFINE_PCI_DEVICE_TABLE` to meet kernel coding style guidelines.
> > This issue was reported by checkpatch.
> 
> Honestly, I prefer the macro -- it stands-out more.  Maybe the style
> guidelines and/or checkpatch should change instead?

The macro is horrid, no other bus has this type of thing just to save a
few characters in typing, so why should PCI be "special" in this regard
anymore?

thanks,

greg k-h
