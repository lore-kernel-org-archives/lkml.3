Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaG3Qrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:47:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57156 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755200AbaG3Qr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:47:29 -0400
Date: Wed, 30 Jul 2014 18:47:21 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Tejun Heo <tj@kernel.org>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 3/8] ata: libahci_platform: move port_map parameters
 into the AHCI structure
Message-ID: <20140730164721.GA15772@kwain>
References: <1406193450-17283-1-git-send-email-antoine.tenart@free-electrons.com>
 <1406193450-17283-4-git-send-email-antoine.tenart@free-electrons.com>
 <20140729144042.GD4791@htj.dyndns.org>
 <20140730082038.GB29900@kwain>
 <20140730153526.GB23734@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140730153526.GB23734@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:35:26AM -0400, Tejun Heo wrote:
> On Wed, Jul 30, 2014 at 10:20:38AM +0200, Antoine Ténart wrote:
> > How do you want me to send the series? There is two conflicts when
> > applying to libata/for-3.17:
> > - patch 4/8: it takes into account a patch not in libata/for-3.17 but
> >   added before rc7. It should be better to first merge rc7, otherwise
> >   some modifications won't make sense.
> > - patch 6/8: "fsl,imx53-ahci" was removed from the documentation in
> >   libata/for-3.17 but not in rc7. Resolving the conflict is really
> >   simple.
> > 
> > I think it's better to apply the whole thing after merging rc7 into
> > libata/for-3.17, because it will only have a really simple conflict to
> > resolve.
> > 
> > Please tell me what do you prefer before I send the updated version.
> 
> Hmmm... does pulling in libata/for-3.16-fixes into libata/for-3.17
> resolves the conflict?  If so, please send the patch on top of the
> merged branch.  I wanna avoid pulling in -rc7 wholesale at this point.

Works for me. I'll cook and send a series based on top of
libata/for-3.16-fixes merged into libata/for-3.17.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
