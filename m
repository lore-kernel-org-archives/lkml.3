Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbaDVNJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:09:27 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:52661 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaDVNJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:09:21 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/3] arm: dts: add device_type="memory" for ste-ccu8540
To: Lee Jones <lee.jones@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
In-Reply-To: <20140422073926.GC17657@lee--X1>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
	<1397756521-29387-2-git-send-email-leif.lindholm@linaro.org>
	<20140422073926.GC17657@lee--X1>
Date: Tue, 22 Apr 2014 14:09:12 +0100
Message-Id: <20140422130912.A4F71C4042C@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 08:39:26 +0100, Lee Jones <lee.jones@linaro.org> wrote:
> > The current .dts for ste-ccu8540 lacks a 'device_type = "memory"' for
> > its memory node, relying on an old ppc quirk in order to discover its
> > memory. Add this, to permit that quirk to be made ppc only.
> > 
> > Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: devicetree@vger.kernel.org
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/boot/dts/ste-ccu8540.dts |    1 +
> >  1 file changed, 1 insertion(+)
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Grant Likely <grant.likely@linaro.org>

g.
