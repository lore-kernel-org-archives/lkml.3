Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794Ab3LII1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:27:31 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48631 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab3LII1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:27:24 -0500
X-Sasl-enc: upmuPCnCVE0utvgEPaiYmJkZ8s/vktZ2mIpagyMfQeUL 1386577642
Date: Sun, 8 Dec 2013 17:55:53 -0800
From: Greg KH <greg@kroah.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org, "'Kamil Debski'" <k.debski@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        m.szyprowski@samsung.com, gautam.vivek@samsung.com,
        "'Mateusz Krawczuk'" <mat.krawczuk@gmail.com>,
        "'Yulgon Kim'" <yulgon.kim@samsung.com>,
        "'Praveen Paneri'" <p.paneri@samsung.com>,
        "'Anton Tikhomirov'" <av.tikhomirov@samsung.com>,
        "'Kumar Gala'" <galak@codeaurora.org>
Subject: Re: [PATCH] usb: ohci-exynos: Change to use phy provided by the
 generic phy framework
Message-ID: <20131209015553.GA27542@kroah.com>
References: <001401ceda8f$67f1ee50$37d5caf0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001401ceda8f$67f1ee50$37d5caf0$%han@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 10:27:49AM +0900, Jingoo Han wrote:
> Change the phy provider used from the old usb phy specific to a new one
> using the generic phy framework.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Kamil Debski <k.debski@samsung.com>
> ---
> Exynos OHCI driver also uses Exynos USB2.0 PHY. Thus, I make this
> patch based-on Kamil Debski's patchset for adding Exynos USB 2.0 PHY
> driver.
> (http://www.spinics.net/lists/linux-samsung-soc/msg24104.html)
> 
>  drivers/usb/host/ohci-exynos.c |   28 ++++++++--------------------
>  1 file changed, 8 insertions(+), 20 deletions(-)

This has some fuzz when applied to my tree, care to redo it against my
usb-next branch of the usb.git tree on git.kernel.org?

thanks,

greg k-h
