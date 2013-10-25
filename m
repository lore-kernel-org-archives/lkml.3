Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab3JYWiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:38:03 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52686 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab3JYWht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:37:49 -0400
Date: Fri, 25 Oct 2013 15:37:45 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Subject: Re: [PATCH v3 1/4] ab8500-charger: Check return value of
 regulator_enable
Message-ID: <20131025223745.GA1157@teo>
References: <1378454473-24508-1-git-send-email-sachin.kamat@linaro.org>
 <20130906093800.GF32654@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130906093800.GF32654@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 10:38:00AM +0100, Lee Jones wrote:
> On Fri, 06 Sep 2013, Sachin Kamat wrote:
> 
> > Check the return value of regulator_enable to silence the following
> > type of warnings:
> > drivers/power/ab8500_charger.c:1390:20: warning: ignoring return value
> > of ‘regulator_enable’, declared with attribute warn_unused_result
> > [-Wunused-result]
> > 
> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > ---
> > Compile tested.
> > 
> > Changes since v2:
> > * removed redundant assignment to false.
> > Changes since v1:
> > * converted dev_err and return to dev_warn as suggested by Lee Jones.
> > ---
> > 
> >  drivers/power/ab8500_charger.c |   16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> Looks good now.
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>

Applied, thanks a lot for the patches and reviews!

Anton
