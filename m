Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3GAWZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:25:35 -0400
Received: from mout.gmx.net ([212.227.17.21]:56391 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab3GAWZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:25:32 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v4] drivers/tpm: add xen tpmfront interface
Date: Tue, 2 Jul 2013 00:32:49 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.0; KDE/4.9.5; x86_64; ; )
Cc: Daniel De Graaf <dgdegra@tycho.nsa.gov>, konrad.wilk@oracle.com,
        leosilva@linux.vnet.ibm.com, adlai@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, mail@srajiv.net,
        shpedoikal@gmail.com, tpmdd@sirrix.com
References: <1372714468-28120-1-git-send-email-dgdegra@tycho.nsa.gov>
In-Reply-To: <1372714468-28120-1-git-send-email-dgdegra@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201307020032.49963.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:n0uCo5gfyMILcEJc9oUOdXeYsHlmmInaTQb5ADMu64weQI9N/+W
 ly0TTu5mpiwE4SC1WkKWpUOyNghrXnr3a6ZacguSKU6B2jI8xAfh9M9MCUzFPCJsfkMIgzs
 7CqdNKPsBLdDOZdCI8Hu8reClThSaH+HsAe7DojPwh0No2LrfyXzmFlyRnvLL2zWxYRpj4T
 QHslpxOAvew4yv5J+KZZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 1. Juli 2013, 23:34:28 schrieb Daniel De Graaf:
> This is a complete rewrite of the Xen TPM frontend driver, taking
> advantage of a simplified frontend/backend interface and adding support
> for cancellation and timeouts.  The backend for this driver is provided
> by a vTPM stub domain using the interface in Xen 4.3.
> 
> Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> Acked-by: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Acked-by: Peter Huewe <peterhuewe@gmx.de>
> Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
> ---

Reviewed, the remaining topics were addressed in this v4.
Reviewed-by: Peter Huewe <peterhuewe@gmx.de>


>From the TPM point of view I'd say it is fine.
Acked-by: Peter Huewe <peterhuewe@gmx.de>

Thanks!

@Konrad: Can you take it through your tree?


Thanks,
Peter
