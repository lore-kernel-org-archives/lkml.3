Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaFYTpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:45:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55286 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaFYTpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:45:12 -0400
Date: Wed, 25 Jun 2014 15:41:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, iss_storagedev@hp.com,
        linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-eata@i-connect.net, devel@driverdev.osuosl.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 00/22] Add and use pci_zalloc_consistent
Message-ID: <20140625194112.GJ3445@tuxdriver.com>
References: <cover.1403530604.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1403530604.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 06:41:28AM -0700, Joe Perches wrote:
> Adding the helper reduces object code size as well as overall
> source size line count.
> 
> It's also consistent with all the various zalloc mechanisms
> in the kernel.
> 
> Done with a simple cocci script and some typing.
> 
> Joe Perches (22):

>   ipw2100: Use pci_zalloc_consistent
>   mwl8k: Use pci_zalloc_consistent
>   rtl818x: Use pci_zalloc_consistent
>   rtlwifi: Use pci_zalloc_consistent

Sure, fine by me.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
