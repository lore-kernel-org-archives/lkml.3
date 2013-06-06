Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3FFHGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:06:17 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58835 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab3FFHGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:06:15 -0400
Date: Thu, 6 Jun 2013 08:06:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: J Keerthy <j-keerthy@ti.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        swarren@wwwdotorg.org, swarren@nvidia.com, rob.herring@calxeda.com,
        rob@landley.net, sameo@linux.intel.com, wim@iguana.be,
        lgirdwood@gmail.com, gg@slimlogic.co.uk, t-kristo@ti.com,
        Ian Lartey <ian@slimlogic.co.uk>
Subject: Re: [PATCH v3] mfd: DT bindings for the palmas family MFD
Message-ID: <20130606070610.GS3370@gmail.com>
References: <1370496441-24620-1-git-send-email-j-keerthy@ti.com>
 <20130606070210.GR3370@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130606070210.GR3370@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Jun 2013, Lee Jones wrote:

> On Thu, 06 Jun 2013, J Keerthy wrote:
> 
> > Add the various binding files for the palmas family of chips. There is a
> > top level MFD binding then a seperate binding for regulators IP blocks on chips.
> > 
> > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> > Reviewed-by: Stephen Warren <swarren@nvidia.com> 
> > ---
> >  Documentation/devicetree/bindings/mfd/palmas.txt   |   49 +++++++++++++
> >  .../devicetree/bindings/regulator/palmas-pmic.txt  |   72 ++++++++++++++++++++
> >  2 files changed, 121 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/palmas.txt
> >  create mode 100644
> > Documentation/devicetree/bindings/regulator/palmas-pmic.tx
> 
> Applied, thanks.

Ah wait. It appears Grant wants to take this.

Unapplied, thanks. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
