Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243AbaGXGmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:42:47 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49530 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934148AbaGXGmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:42:45 -0400
X-Sasl-enc: Wejzjv/5bQggU1j1Ud0rFj6ZCzqIWPzhVMfDMRm6bwwe 1406184163
Date: Wed, 23 Jul 2014 23:42:18 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pratyush Anand <pratyush.anand@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the arm-soc tree
Message-ID: <20140724064218.GB22398@kroah.com>
References: <20140724162811.5e12107a@canb.auug.org.au>
 <20140724163329.03002387@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724163329.03002387@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 04:33:29PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Thu, 24 Jul 2014 16:28:11 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the usb tree got a conflict in
> > drivers/phy/Kconfig between commit 64562e99477f ("phy: Add drivers for
> > PCIe and SATA phy on SPEAr13xx") from the arm-soc tree and commit
> > 1de990d8a169 ("phy: qcom: Add driver for QCOM APQ8064 SATA PHY") from
> > the usb tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> 
> Also drivers/phy/Makefile

Both look good, thanks.

greg k-h
