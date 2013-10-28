Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab3J1Wyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 18:54:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49670 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab3J1Wyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 18:54:49 -0400
Date: Mon, 28 Oct 2013 15:54:32 -0700
From: Mark Brown <broonie@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, dave.jiang@intel.com,
        Mauro Carvalho Chehab <mchehab@redhat.com>, b.zolnierkie@samsung.com,
        vinod.koul@intel.com, t.figa@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, Viresh Kumar <viresh.linux@gmail.com>,
        Tejun Heo <tj@kernel.org>, linux@arm.linux.org.uk,
        Jon Mason <jon.mason@intel.com>, David Woodhouse <dwmw2@infradead.org>
Message-ID: <20131028225432.GA14561@sirena.org.uk>
References: <1382117733-16720-14-git-send-email-b.zolnierkie@samsung.com>
 <20131022210834.31394.26173.stgit@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20131022210834.31394.26173.stgit@viggo.jf.intel.com>
X-Cookie: Slow day.  Practice crawling.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 13/13] dmaengine: remove DMA unmap flags
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 02:08:34PM -0700, Dan Williams wrote:
> From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> 
> Remove no longer needed DMA unmap flags:
> - DMA_COMPL_SKIP_SRC_UNMAP
> - DMA_COMPL_SKIP_DEST_UNMAP
> - DMA_COMPL_SRC_UNMAP_SINGLE
> - DMA_COMPL_DEST_UNMAP_SINGLE

Acked-by: Mark Brown <broonie@linaro.org>
