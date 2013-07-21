Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3GUOdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 10:33:55 -0400
Received: from jdl.com ([208.123.74.7]:44758 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519Ab3GUOdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 10:33:54 -0400
X-Greylist: delayed 2844 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jul 2013 10:33:54 EDT
Message-Id: <E1V0txk-0007v7-0J@jdl.com>
To: Linus Walleij <linus.walleij@linaro.org>
cc: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
In-reply-to: <CACRpkdb2bPQOD2CBzbF0K33mZZwKwGSCO6B4djesVd5DR-Z1tA@mail.gmail.com>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org> <1374290388-19308-3-git-send-email-grant.likely@linaro.org> <CACRpkdb2bPQOD2CBzbF0K33mZZwKwGSCO6B4djesVd5DR-Z1tA@mail.gmail.com>
Comments: In-reply-to Linus Walleij <linus.walleij@linaro.org>
   message dated "Sat, 20 Jul 2013 18:20:50 +0200."
Date: Sun, 21 Jul 2013 08:46:11 -0500
From: Jon Loeliger <jdl@jdl.com>
X-Spam-Score: -0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Jul 20, 2013 at 5:19 AM, Grant Likely <grant.likely@linaro.org> wrote
> :
> 
> > Device tree bindings require a lot more attention than they used to.
> > We've got a group of volunteers willing to take over maintaining
> > bindings. This patch adds them to the MAINTAINERS file.
> >
> > This group still needs to work out a process for maintainership and how
> > they are going to work together. I recommend that they set up a shared
> > tree on git.kernel.org that they each have commit access to similar to
> > the tip tree or the arm-soc tree, but it is up to them.
> >
> > Signed-off-by: Grant Likely <grant.likely@linaro.org>
> > Cc: Pawel Moll <pawel.moll@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Stephen Warren <swarren@wwwdotorg.org>
> > Cc: Ian Campbell <ian.campbell@citrix.com>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Olof Johansson <olof@lixom.net>
> > Cc: devicetree-discuss@lists.ozlabs.org
> > Cc: devicetree@vger.kernel.org
> 
> Excellent move.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Perhaps it is time to also place the official repo
of the Device Tree Compiler on git,kernel.org as well?

Other opinions?

jdl
