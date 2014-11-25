Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaKYJpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:45:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaKYJpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:45:11 -0500
Message-ID: <54744FA4.6060609@suse.de>
Date: Tue, 25 Nov 2014 10:45:08 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org
CC: Christoph Hellwig <hch@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] wd719x: Introduce Western Digital WD7193/7197/7296
 PCI SCSI card driver
References: <1416867882-29344-1-git-send-email-linux@rainbow-software.org> <1416867882-29344-3-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1416867882-29344-3-git-send-email-linux@rainbow-software.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 11:24 PM, Ondrej Zary wrote:
> Introduce wd719x, a driver for Western Digital WD7193, WD7197 and WD7296 PCI
> SCSI controllers based on WD33C296A chip.
> Tested with WD7193 card.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 21284 (AG Nürnberg)
