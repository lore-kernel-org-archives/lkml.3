Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaJON4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:56:14 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60756 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaJON4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:56:13 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Romain Perier <romain.perier@gmail.com>, devicetree@vger.kernel.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org, robh@kernel.org,
        mark.rutland@arm.com
Subject: Re: [RFC v3 PATCH 1/5] of: Add standard property for poweroff capability
Date: Wed, 15 Oct 2014 15:56:03 +0200
Message-ID: <40398493.mf2VbOGMuV@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20141015134245.GH27755@sirena.org.uk>
References: <1413268273-15151-1-git-send-email-romain.perier@gmail.com> <20141015124142.92D0EC40B00@trevor.secretlab.ca> <20141015134245.GH27755@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 15. Oktober 2014, 15:42:45 schrieb Mark Brown:
> On Wed, Oct 15, 2014 at 02:41:42PM +0200, Grant Likely wrote:
> > , Romain Perier <romain.perier@gmail.com>
> > 
> >  wrote:
> > > Several drivers create their own devicetree property when they register
> > > poweroff capabilities. This is for example the case for mfd, regulator
> > > or power drivers which define "vendor,system-power-controller" property.
> > > This patch adds support for a standard property "poweroff-source"
> > > which marks the device as able to shutdown the system.
> > > 
> > > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > 
> > Acked-by: Grant Likely <grant.likely@linaro.org>
> > 
> > And same for the documentation patches.
> 
> I guess I should apply these (except the DTS update) since the first
> user that's being added is a regulator driver?

I'd think so.
In any case, I'll take the "ARM: dts: ..." patch if you take the others.


Heiko
