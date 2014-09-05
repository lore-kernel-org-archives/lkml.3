Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbaIEBzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 21:55:19 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35548 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaIEBzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 21:55:16 -0400
Date: Fri, 5 Sep 2014 10:55:07 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@skyworksinc.com>
Subject: Re: [PATCH v2.2 2/2] dt-bindings: Adding compatible attribute for
 SKY81452 regulator
Message-ID: <20140905015507.GA2636@jack-ThinkPad-T520>
References: <20140813190423.GI17528@sirena.org.uk>
 <1409539218-5571-1-git-send-email-jack.yoo@skyworksinc.com>
 <1409539218-5571-3-git-send-email-jack.yoo@skyworksinc.com>
 <20140901103158.GO29327@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140901103158.GO29327@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 11:31:58AM +0100, Mark Brown wrote:
> On Mon, Sep 01, 2014 at 11:40:18AM +0900, Gyungoh Yoo wrote:
> > Adding compatible attribute for SKY81452 regulator driver.
> 
> >  Required properties:
> > +- compatible	: Must be "skyworks,sky81452-regulator"
> 
> Why is this a good idea - can this driver be used for anything other
> than a sky81452?

Thank you for the answer.

Yes. There is a possibility that this driver will be used by similar device with SKY81452.
