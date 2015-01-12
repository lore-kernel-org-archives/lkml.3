Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbbALP10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:27:26 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:59470 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbbALP1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:27:24 -0500
Date: Mon, 12 Jan 2015 10:27:00 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] moving from pci to dma
Message-ID: <20150112102700.2aa3b17e@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <20150112100239.GA9009@sloth>
References: <20150112100239.GA9009@sloth>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-NRLCMF-Spam-Score: () hits=0
X-NRLCMF-Virus-Scanned: No virus found
X-NRLCMF-Languages: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There doesn't seem to be a patch for review?

On Mon, 12 Jan 2015 11:02:39 +0100
Quentin Lambert <lambert.quentin@gmail.com> wrote:

> This patch replaces the references to the deprecated pci api with the
> corresponding dma api.
...
> Quentin Lambert (1):
>   atm: remove deprecated use of pci api
> 
>  drivers/atm/eni.c       | 8 +++++---
>  drivers/atm/he.c        | 2 +-
>  drivers/atm/lanai.c     | 9 +++++----
>  drivers/atm/nicstar.c   | 4 ++--
>  drivers/atm/solos-pci.c | 2 +-
>  drivers/atm/zatm.c      | 8 +++++---
>  6 files changed, 19 insertions(+), 14 deletions(-)
> 

