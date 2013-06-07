Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3FGAin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:38:43 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:46194 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3FGAim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:38:42 -0400
Date: Thu, 6 Jun 2013 17:34:27 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: anish singh <anish198519851985@gmail.com>
Cc: Axel Lin <axel.lin@ingics.com>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power_supply: generic-adc-battery: Fix checking if none
 of the channels are supported
Message-ID: <20130607003426.GF7052@lizard.sbx05280.losalca.wayport.net>
References: <1369417304.9205.1.camel@phoenix>
 <CAK7N6vr9Jynd0ezXTRb8spGtxAKsRnrYGOtgTiYMPDDz_u1vMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAK7N6vr9Jynd0ezXTRb8spGtxAKsRnrYGOtgTiYMPDDz_u1vMA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 11:57:37AM +0530, anish singh wrote:
> On Fri, May 24, 2013 at 11:11 PM, Axel Lin <axel.lin@ingics.com> wrote:
> > If none of the channels are supported, index is 0.
> > Also ensure to return error code instead of 0 in goto second_mem_fail path.
> >
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Acked-by: anish kumar <anish198519851985@gmail.com>

Applied, thanks!

Anton
