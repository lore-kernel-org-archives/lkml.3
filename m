Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3GUA3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 20:29:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38446 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753597Ab3GUA3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 20:29:38 -0400
Message-ID: <1374366577.1940.10.camel@joe-AO722>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
From: Joe Perches <joe@perches.com>
To: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        devicetree@vger.kernel.org
Date: Sat, 20 Jul 2013 17:29:37 -0700
In-Reply-To: <CAOesGMhaAy93J=Q1STZUHHA-SbH+WXCVuUn0ef14_18du2dk6w@mail.gmail.com>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
	 <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
	 <CAOesGMhaAy93J=Q1STZUHHA-SbH+WXCVuUn0ef14_18du2dk6w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-20 at 17:17 -0700, Olof Johansson wrote:
> On Fri, Jul 19, 2013 at 8:19 PM, Grant Likely <grant.likely@linaro.org> wrote:
> > Device tree bindings require a lot more attention than they used to.
> > We've got a group of volunteers willing to take over maintaining
> > bindings. This patch adds them to the MAINTAINERS file.
[]
> > diff --git a/MAINTAINERS b/MAINTAINERS
[]
> > +OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS
[]
> > +F:     arch/*/
[]
> This seems a bit broad.

Yep, that's every file anywhere under arch.


