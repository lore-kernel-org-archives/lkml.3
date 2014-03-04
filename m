Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbaCDOEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:04:16 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:58076 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387AbaCDOEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:04:14 -0500
Date: Tue, 4 Mar 2014 09:04:09 -0500
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, DCG_UPD_stlinux_kernel@list.st.com,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 3/3] ahci: st: Add support for ST's SATA IP
Message-ID: <20140304140409.GA30338@htj.dyndns.org>
References: <1393328481-7251-1-git-send-email-lee.jones@linaro.org>
 <1393328481-7251-3-git-send-email-lee.jones@linaro.org>
 <20140226144721.GP9195@lee--X1>
 <4575362.nxyAcPCJSW@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4575362.nxyAcPCJSW@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 02:48:54PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Wednesday, February 26, 2014 02:47:21 PM Lee Jones wrote:
> > ahci: st: Add support for ST's SATA IP
> > 
> > Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> > index b4a9262..ee7a3dc 100644
> > --- a/drivers/ata/Kconfig
> > +++ b/drivers/ata/Kconfig
> > @@ -97,6 +97,15 @@ config SATA_AHCI_PLATFORM
> >  
> >  	  If unsure, say N.
> >  
> > +config SATA_AHCI_ST
> 
> It would be better to name it just ACHI_ST for consistency with
> existing config options (AHCI_IMX and AHCI_SUNXI).

The patch is already in for-3.15 branch.  Lee, can you please post an
incremental patch addressing Bart's review points?

Thanks.

-- 
tejun
