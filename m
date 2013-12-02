Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3LBOMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:12:42 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9146 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab3LBOMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:12:39 -0500
X-AuditID: cbfec7f4-b7fea6d0000026ac-75-529c9555e59f
Message-id: <1385993555.5573.3.camel@AMDC1943>
Subject: Re: [PATCH v5 1/2] regulator: max14577: Add regulator driver for Maxim
 14577
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Mon, 02 Dec 2013 15:12:35 +0100
In-reply-to: <20131127162859.GD14725@sirena.org.uk>
References: <1385559982-32039-1-git-send-email-k.kozlowski@samsung.com>
 <20131127152042.GY14725@sirena.org.uk> <20131127152358.GP3296@lee--X1>
 <20131127154221.GZ14725@sirena.org.uk> <20131127161323.GS3296@lee--X1>
 <20131127162859.GD14725@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e/4Zd3QqXOCDHad0LbYOGM9q8XUh0/Y
	LOYfOcdqce7VSkaLs01v2C3ufz3KaPHtSgeTxcK2JSwWl3fNYbNYe+Quu8XS6xeZLCZMX8ti
	cXjFASaLdS+ns1ic7ma1eHWwjcVBwGPNvDWMHgs+X2H32DnrLrvHyuVf2Dw2repk83i1eiar
	x51re9g85p0M9OjbsorR4/MmOY+Nc0MDuKO4bFJSczLLUov07RK4Mrq3HGQteMRe0TV9NlsD
	YwNbFyMnh4SAicTsz7uYIWwxiQv31gPFuTiEBJYyStw40sUO4XxmlJhx5zITSBWvgJ7EsYM3
	GEFsYYFwiSlvZ7CD2GwCxhKbly8BmyoioCxx9fteFhCbWeAIi8TbeUYgNouAqsTaiZvAtnEC
	1e/8+YMJYkETk8S6n6uhGtQlJs1bBHWSksTu9k52iLi8xOY1b5khjhCU+DH5HssERoFZSFpm
	ISmbhaRsASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQyPuyg3HxMatDjAIcjEo8vBdO
	zA4SYk0sK67MPcQowcGsJMK7Y9KcICHelMTKqtSi/Pii0pzU4kOMTBycUg2Mmp/Ond5UP+On
	9f2TewIn+b/OEox9t+3/gn8BDys2W9XMj9/+OJuP2fbI4eW7ub/9/r7xxbtlLxtYC3dPPqYU
	5HLwy/F9Z1q7npdNO6anYDg/8XpW94Jj6g58t4JfB1pu2r3D5E/46ozVvMxy2jP3cv900Fm3
	er6iXmGBtNaeDX0el/h+uUr0bVBiKc5INNRiLipOBAA0GY3TmgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, 2013-11-27 at 16:28 +0000, Mark Brown wrote:
> On Wed, Nov 27, 2013 at 04:13:23PM +0000, Lee Jones wrote:
> > On Wed, 27 Nov 2013, Mark Brown wrote:
> 
> > > The usual thing to do is of_get_child_by_name() on the parent to get the
> > > container to search in.
> 
> > What do you mean when you say 'usual thing'? Only the max8998 does
> > this currently. IMHO the better way to do it for MFD devices is
> > provide a compatible string and let the framework does the rest for
> > you.
> 
> No, as3722, Palmas and three of the TPS chips do the same thing.  If it
> were a purely Linux-internal thing I'd probably agree with you but as it
> is we'd just be adding compatible strings in everyone's DTs to save one
> line of code in the kernel.

Lee applied the MFD part of max14577, including the "of_compatible" of
max14577-regulator.

Do you wish me to change the patch to previous version using
of_get_child_by_name()?

Best regards,
Krzysztof



