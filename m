Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965471AbaGRQau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:30:50 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48998 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934509AbaGRQar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:30:47 -0400
Date: Fri, 18 Jul 2014 12:22:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Benoit Taine <benoit.taine@lip6.fr>
Cc: linux-pci@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        ath9k-devel@venema.h4ckr.net, linux-hippi@sunsite.dk,
        dri-devel@lists.freedesktop.org, linux-acenic@sunsite.dk,
        wil6210@qca.qualcomm.com, platform-driver-x86@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-mips@linux-mips.org, users@rt2x00.serialmonkey.com,
        linux-rdma@vger.kernel.org, virtualization@lists.linux-foundation.org,
        industrypack-devel@lists.sourceforge.net, linux-can@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-crypto@vger.kernel.org,
        MPT-FusionLinux.pdl@avagotech.com, devel@linuxdriverproject.org,
        xen-devel@lists.xenproject.org, linux-pcmcia@lists.infradead.org,
        e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/25] Replace DEFINE_PCI_DEVICE_TABLE macro use
Message-ID: <20140718162213.GC31114@tuxdriver.com>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 05:26:47PM +0200, Benoit Taine wrote:
> We should prefer `const struct pci_device_id` over
> `DEFINE_PCI_DEVICE_TABLE` to meet kernel coding style guidelines.
> This issue was reported by checkpatch.

Honestly, I prefer the macro -- it stands-out more.  Maybe the style
guidelines and/or checkpatch should change instead?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
