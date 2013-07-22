Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3GVAny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:43:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44902 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753860Ab3GVAnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:43:53 -0400
Message-ID: <1374453831.2061.10.camel@joe-AO722>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
From: Joe Perches <joe@perches.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Date: Sun, 21 Jul 2013 17:43:51 -0700
In-Reply-To: <CACxGe6tJedLnM6FmvuQWTpGNFsefTn14cbnBMoWnr1gfA0seoQ@mail.gmail.com>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
	 <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
	 <CAOesGMhaAy93J=Q1STZUHHA-SbH+WXCVuUn0ef14_18du2dk6w@mail.gmail.com>
	 <1374366577.1940.10.camel@joe-AO722>
	 <CACxGe6tqisx19LP=5gPyF1iuBKedTLp0yK+WgmqG5Cf+a95Taw@mail.gmail.com>
	 <CACxGe6tJedLnM6FmvuQWTpGNFsefTn14cbnBMoWnr1gfA0seoQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 01:36 +0100, Grant Likely wrote:
> On Sun, Jul 21, 2013 at 10:46 AM, Grant Likely <grant.likely@linaro.org> wrote:
> > On Sun, Jul 21, 2013 at 1:29 AM, Joe Perches <joe@perches.com> wrote:
> >> On Sat, 2013-07-20 at 17:17 -0700, Olof Johansson wrote:
> >>> On Fri, Jul 19, 2013 at 8:19 PM, Grant Likely <grant.likely@linaro.org> wrote:
> >>> > Device tree bindings require a lot more attention than they used to.
> >>> > We've got a group of volunteers willing to take over maintaining
> >>> > bindings. This patch adds them to the MAINTAINERS file.
> >> []
> >>> > diff --git a/MAINTAINERS b/MAINTAINERS
> >> []
> >>> > +OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS
> >> []
> >>> > +F:     arch/*/
> >> []
> >>> This seems a bit broad.
> >>
> >> Yep, that's every file anywhere under arch.
> >
> > yeah, that was a c/p mistake. I'll drop that line before committing.
> 
> In fact, if things go well with the schema tool, it would be possible
> to leave out the .dts files entirely as far as binding review goes.
> The binding would be the important part and the .dts files would be
> checked against that. That's something for the future though.

btw: please add a terminating slash to
     the file pattern directories

+F:     Documentation/devicetree/
+F:     arch/*/boot/dts/
+F:     include/dt-bindings/


