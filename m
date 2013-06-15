Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3FOT4I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 15:56:08 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:53416 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3FOT4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 15:56:06 -0400
MIME-Version: 1.0
In-Reply-To: <2555796.PtkImJGaK8@avalon>
References: <1370988237-30593-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<20130612124833.A3ADB3E0A56@localhost>
	<2555796.PtkImJGaK8@avalon>
Date: Sat, 15 Jun 2013 21:56:05 +0200
Message-ID: <CACRpkdaF7V3FGhNNj+N+Dc-NWhsfQ=bqh+ETx0wGBFbLmxfGTw@mail.gmail.com>
Subject: Re: [RFC] pinctrl: generic: Add DT bindings
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 12:39 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

>         mmcif_pins: mmcif {
>                 mux {
>                         renesas,groups = "mmc0_data8_0", "mmc0_ctrl_0";
>                         renesas,function = "mmc0";
>                 };
>                 cfg {
>                         renesas,groups = "mmc0_data8_0";
>                         renesas,pins = "PORT279";
>                         bias-pull-up = <1>;

If I understood your code correctly that last statement can *optionally*
be written like just:

 bias-pull-up;

Without the parameter?

I think that Heiko's implementation does this anyway.

Yours,
Linus Walleij
