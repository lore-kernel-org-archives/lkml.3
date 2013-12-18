Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab3LRRNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:13:25 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:39063 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3LRRNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:13:23 -0500
X-Auth-Info: kUNsh7yj55uSFSTlEyvM963CPk5jUWrJslnU6f4oAhw=
From: Marek Vasut <marex@denx.de>
To: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH 3.5 057/103] HID: add quirk for Freescale i.MX23 ROM recovery
Date: Wed, 18 Dec 2013 18:13:20 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Jiri Kosina <jkosina@suse.cz>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com> <201312172039.03504.marex@denx.de> <20131218161613.GC4452@hercules>
In-Reply-To: <20131218161613.GC4452@hercules>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201312181813.20923.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 18, 2013 at 05:16:13 PM, Luis Henriques wrote:
> Hi Marek,
> 
> On Tue, Dec 17, 2013 at 08:39:03PM +0100, Marek Vasut wrote:
> > On Tuesday, December 17, 2013 at 07:12:46 PM, Luis Henriques wrote:
> > > 3.5.7.28 -stable review patch.  If anyone has any objections, please
> > > let me know.
> > 
> > Hi,
> > 
> > while I cannot test this anymore as I don't have these machines with
> > ubuntu 12.04.3 available anymore (I won't do a distro war, don't worry
> > :) ), I have two simple questions:
> > 
> > a) Will you be able to pick the other two patches from [1] ?
> 
> Sure, if you believe these 2 patches are applicable to the 3.5 extended
> stable kernel, I can queue them for the next release.

Thank you!

> > b) Will these patches make it into ubuntu 12.03.n ?
> 
> Please note that this is the 3.5 extended stable kernel, not an Ubuntu
> kernel -- it follows the same rules as the official stable kernels.
> Eventually, this kernel release will be picked by the Ubuntu Quantal kernel
> (which is based on 3.5).

Sure, I am not an ubuntu expert so sorry about the misplaced question.

> > I will have these machines available in january again, so I will be able
> > to test.
> > 
> > Thank you!
> > 
> > [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1258332
> > 
> > Best regards,
> > Marek Vasut
> 
> Cheers,
> --
> Luis

Best regards,
Marek Vasut
