Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbaA2BNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 20:13:19 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:51434 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755157AbaA2BNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 20:13:17 -0500
Date: Wed, 29 Jan 2014 01:13:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the imx-mxs tree with the arm tree
Message-ID: <20140129011310.GT15937@n2100.arm.linux.org.uk>
References: <20140129113514.86275e22015dea313d78d5e1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129113514.86275e22015dea313d78d5e1@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 11:35:14AM +1100, Stephen Rothwell wrote:
> Hi Shawn,
> 
> Today's linux-next merge of the imx-mxs tree got a conflict in
> arch/arm/boot/dts/Makefile between commits 208d7baf8085 ("ARM: imx:
> initial SolidRun HummingBoard support") and 971488f1149f ("ARM: imx:
> initial SolidRun Cubox-i support") from the arm tree and various commits
> from the imx-mxs tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Nice easy add/add which Linus won't complain about.  Thanks Stephen.

This should move to between Linus' and Shawn's tree over the next
couple of days since I've now sent my final pull request for this
window.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
