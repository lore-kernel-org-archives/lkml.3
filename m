Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946578Ab3BHM7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:59:33 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33522 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946536Ab3BHM7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:59:30 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] input: Extend matrix-keypad device tree binding
To: Stephen Warren <swarren@wwwdotorg.org>, Simon Glass <sjg@chromium.org>
Cc: Roland Stigge <stigge@antcom.de>, Vincent Palatin <vpalatin@chromium.org>,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Luigi Semenzato <semenzato@chromium.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-input@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
In-Reply-To: <50F0473F.404@wwwdotorg.org>
References: <1357868492-16023-1-git-send-email-sjg@chromium.org> <50F0473F.404@wwwdotorg.org>
Date: Fri, 08 Feb 2013 12:59:24 +0000
Message-Id: <20130208125924.65E803E2B73@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013 10:09:19 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/10/2013 06:41 PM, Simon Glass wrote:
> > Some matrix keypad drivers can support different numbers of rows and
> > columns. Add a generic binding for these.
> > 
> > Implementation note:
> > 
> > In order to implement this binding in the kernel, we will need to modify
> > matrix_keypad_() to look up the number of rows and cols in
> > the keymap. Perhaps this could be done by passing 0 for these parameters?
> > Many of the parameters can already be set to NULL. Ick.
> 
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Applied, thanks.

g.

