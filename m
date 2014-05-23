Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaEWOMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:12:12 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:59644 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbaEWOML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:12:11 -0400
Message-ID: <1400854329.25785.0.camel@violet>
Subject: Re: [PATCH] pinctrl: Enable "power-source" to be extracted from DT
 files
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 23 May 2014 17:12:09 +0300
In-Reply-To: <CACRpkdZyLxMTSygRP6pD-mxghQ_D6tQ821tvn8GYw0Rnh9hZoQ@mail.gmail.com>
References: <1400685297-30754-1-git-send-email-iivanov@mm-sol.com>
	 <CACRpkdZyLxMTSygRP6pD-mxghQ_D6tQ821tvn8GYw0Rnh9hZoQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-23 at 15:58 +0200, Linus Walleij wrote:
> On Wed, May 21, 2014 at 5:14 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> 
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >
> > Add "power-source" property to generic options used for DT parsing files.
> > This  enables drivers, which use generic pin configurations, to get the
> > value passed to this property.
> >
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> 
> Great! But please also patch:
> Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> 
> In this same patch to add the binding, and respin.


Sure. Thanks

Ivan

> 
> Yours,
> Linus Walleij


