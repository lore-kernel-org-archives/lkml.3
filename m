Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaH2CWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 22:22:06 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35318 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaH2CWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 22:22:03 -0400
Date: Fri, 29 Aug 2014 11:21:55 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@skyworksinc.com>, lee.jones@linaro.org
Subject: Re: [PATCH v2 2/7] Adding Skyworks SKY81452 regulator driver
Message-ID: <20140829022155.GA28641@jack-ThinkPad-T520>
References: <1409222307-23225-1-git-send-email-jack.yoo@skyworksinc.com>
 <1409222797-23343-1-git-send-email-jack.yoo@skyworksinc.com>
 <20140828110254.GN17528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140828110254.GN17528@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 12:02:54PM +0100, Mark Brown wrote:
> On Thu, Aug 28, 2014 at 07:46:37PM +0900, Gyungoh Yoo wrote:
> > v2:
> > Added 'compatible' attribute in the driver
> > Added message for exception or errors.
> 
> This driver has already been applied, please send any changes as
> incremental patches against current code.  I would *not* expect to see
> a compatible being defined for a MFD function device though unless it's
> genuinely reusable.

I am really sorry about confusing. I will resumit this regulator driver as the incremental patches.

BTW,
as Lee Jones-MFD supporter mentioned,
MFD core provides infrastructure for child drivers using compatible.
https://lkml.org/lkml/2014/8/27/132

I want your opinion.

Thank you.
