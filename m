Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaJHIvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:51:38 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52222 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaJHIvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:51:36 -0400
Date: Wed, 8 Oct 2014 17:51:29 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        jack.yoo@skyworksinc.com
Subject: Re: [RESUBMIT PATCH v3 7/8] regulator: sky81452: Add compatible
 string for device binding
Message-ID: <20141008085129.GA3362@jack-ThinkPad-T520>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
 <1412658667-8196-1-git-send-email-jack.yoo@skyworksinc.com>
 <20141007125221.GG4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141007125221.GG4609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 01:52:21PM +0100, Mark Brown wrote:
> On Tue, Oct 07, 2014 at 02:11:07PM +0900, Gyungoh Yoo wrote:
> > Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> 
> Several problems here:
> 
>  - I don't have patches 1-6 or the cover letter for this series - what
>    are the dependencies?
>  - I can't see any sign that my concerns about the driver not actually
>    being reusable have been addressed here.
>  - This patch appears to do way more than add a compatible string, for
>    example:

I am sorry the recipients of each patch and cover letter was different.
I will resubmit soon.

> 
> > -	np = of_get_child_by_name(dev->parent->of_node, "regulator");
> > -	if (unlikely(!np)) {
> > +	if (!np) {
> >  		dev_err(dev, "regulator node not found");
> > -		return NULL;
> > +		return ERR_PTR(-ENODATA);


