Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3LRQQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:16:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39212 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3LRQQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:16:17 -0500
Date: Wed, 18 Dec 2013 16:16:13 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Marek Vasut <marex@denx.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3.5 057/103] HID: add quirk for Freescale i.MX23 ROM
 recovery
Message-ID: <20131218161613.GC4452@hercules>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
 <1387304012-23805-58-git-send-email-luis.henriques@canonical.com>
 <201312172039.03504.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312172039.03504.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Tue, Dec 17, 2013 at 08:39:03PM +0100, Marek Vasut wrote:
> On Tuesday, December 17, 2013 at 07:12:46 PM, Luis Henriques wrote:
> > 3.5.7.28 -stable review patch.  If anyone has any objections, please let me
> > know.
> 
> Hi,
> 
> while I cannot test this anymore as I don't have these machines with ubuntu 
> 12.04.3 available anymore (I won't do a distro war, don't worry :) ), I have two 
> simple questions:
> 
> a) Will you be able to pick the other two patches from [1] ?

Sure, if you believe these 2 patches are applicable to the 3.5 extended
stable kernel, I can queue them for the next release.

> b) Will these patches make it into ubuntu 12.03.n ?

Please note that this is the 3.5 extended stable kernel, not an Ubuntu
kernel -- it follows the same rules as the official stable kernels.
Eventually, this kernel release will be picked by the Ubuntu Quantal kernel
(which is based on 3.5).

> 
> I will have these machines available in january again, so I will be able to 
> test.
> 
> Thank you!
> 
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1258332
> 
> Best regards,
> Marek Vasut

Cheers,
--
Luis
