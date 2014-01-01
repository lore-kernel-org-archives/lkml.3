Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaAAWVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 17:21:00 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:48154 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaAAWU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 17:20:58 -0500
X-Auth-Info: O40L8dIcZd/yT6wdeKF9zwFBdjKbPYS5LY9wrA607QM=
From: Marek Vasut <marex@denx.de>
To: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCHv5 RESEND 4/4] iio: mxs-lradc: convert is_divided to a bitmap
Date: Wed, 1 Jan 2014 20:31:52 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>, lars@metafoo.de,
        harald@ccbib.org, hector.palacios@digi.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1387820884-28140-1-git-send-email-alexandre.belloni@free-electrons.com> <1387820884-28140-5-git-send-email-alexandre.belloni@free-electrons.com> <52C426C7.8090706@kernel.org>
In-Reply-To: <52C426C7.8090706@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201401012031.52593.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 01, 2014 at 03:31:35 PM, Jonathan Cameron wrote:
> On 23/12/13 17:48, Alexandre Belloni wrote:
> > mxs_lradc.is_divided was an unsigned long array. Convert it to a bitmap
> > to save some memory.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Hi Alexandre,
> 
> I've applied this patch, but would have prefered that you post this one
> in separate series. It is a perfectly valid cleanup, but introducing it
> late in a series leads to uneven reviewing.  Anyhow, as it's trivial and
> I doubt Marek will mind, I've applied it anyway in a new years burst of
> trying to clear the outstanding stuff in my in box ;)
> 
> Applied to the togreg branch of iio.git
> 
> Thanks,

I dont mind, thanks for geting these in. And happy new year to you guys :)

Best regards,
Marek Vasut
