Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab3CFBJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:09:29 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:45595 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3CFBJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:09:28 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] mfd: palmas: is_palmas_charger needed by multiple drivers
To: Samuel Ortiz <sameo@linux.intel.com>, Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        ldewangan@nvidia.com, Graeme Gregory <gg@slimlogic.co.uk>
In-Reply-To: <20130304104449.GB25973@sortiz-mobl>
References: <1361890048-24555-1-git-send-email-ian@slimlogic.co.uk> <20130304104449.GB25973@sortiz-mobl>
Date: Wed, 06 Mar 2013 09:09:22 +0800
Message-Id: <20130306010922.206B73E0AF4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013 11:44:49 +0100, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Ian,
> 
> On Tue, Feb 26, 2013 at 02:47:28PM +0000, Ian Lartey wrote:
> > is_palmas_charger checks for the presence of charging
> > functionality in the device
> > 
> > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> > Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> > Acked-by: Laxman Dewangan<ldewangan@nvidia.com>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Hi Samuel,

I think you better take this through the mfd tree. I can't take it in
gpio because there are other trees that need it also. I'll drop the gpio
patch that depends on this one and let Ian submit a new series that goes
on top of this.

g.

