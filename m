Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3HVJZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:25:20 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:34807 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3HVJZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:25:17 -0400
Date: Thu, 22 Aug 2013 10:25:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Florian Lobmaier <florian.lobmaier@ams.com>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 4/4] mfd: as3722: introduce regmap support
Message-ID: <20130822092512.GD22023@lee--X1>
References: <1376997210-32631-1-git-send-email-florian.lobmaier@ams.com>
 <1376997210-32631-5-git-send-email-florian.lobmaier@ams.com>
 <20130820120800.GN23699@lee--X1>
 <20130821182851.GJ26118@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130821182851.GJ26118@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013, Mark Brown wrote:

> On Tue, Aug 20, 2013 at 01:08:00PM +0100, Lee Jones wrote:
> > On Tue, 20 Aug 2013, Florian Lobmaier wrote:
> 
> > > Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
> > > ---
> > >  drivers/mfd/as3722-regmap.c |  417 +++++++++++++++++++++++++++++++++++++++++++
> > >  1 files changed, 417 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/mfd/as3722-regmap.c
> 
> > I'll leave the review of this file to Mark, but it should be added
> > either when you start calling the functions, or at least before they
> > are used, or else the preceding commits won't build. This would cause
> > someone a major headache if their bisect landed in the middle of your
> > patches.
> 
> Mark wasn't CCed and only happened to notice this on the list...  might
> be worth checking!

We knew you'd get round to it at one point. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
