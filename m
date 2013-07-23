Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072Ab3GWSJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:09:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:40057 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933952Ab3GWSJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:09:23 -0400
X-IronPort-AV: E=Sophos;i="4.89,729,1367971200"; 
   d="scan'208";a="38787261"
Message-ID: <1374602957.6623.142.camel@hastur.hellion.org.uk>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
From: Ian Campbell <ian.campbell@citrix.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Pawel Moll <pawel.moll@arm.com>, Rob Herring <robherring2@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Tue, 23 Jul 2013 19:09:17 +0100
In-Reply-To: <51EEC49A.4080909@wwwdotorg.org>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
	  <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
	  <1374511851.3609.10.camel@hornet> <51ED9018.1020003@gmail.com>
	 <1374599667.25700.92.camel@hornet> <51EEC49A.4080909@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 10:59 -0700, Stephen Warren wrote:

> I think the solution is to introduce some new shared/common location for
> shared/common *.dtsi files, into the kernel tree, in the interim.
> 
> When *.dts move out of the kernel, this common location can simply be
> consumed as part of the DT tree re-organization.
> 
> Or perhaps, we could move *.dts around in the kernel to match the
> proposed DT tree structure before that point in time?

FWIW I can easily handle any transformation as part of the automated
extraction into the device-tree.git. If it can expressed as a sed script
then so much the better, e.g. the current rules are
http://xenbits.xen.org/gitweb/?p=people/ianc/device-tree-rebasing.git;a=blob;f=scripts/rewrite-paths.sed;h=f7a157d1b486bac058f50e42cf7bedc8630e54ff;hb=HEAD.
If it gets too complicated for sed I can always switch to something
else.

I'm already pending a complete rebuild of the export to add in the
Documentation/devicetree/bindings sub tree but since it takes an age to
run I was waiting for the output of this conversation before kicking
that off.

Ian.


