Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab3LaB1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 20:27:38 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:19752 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab3LaB1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 20:27:37 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] regulator: act8865: register all regulators regardless
 of how many are used
Thread-Topic: [PATCH] regulator: act8865: register all regulators regardless
 of how many are used
Thread-Index: AQHPAd3v0qCIzbXZekmlICQ4j3JUrJpsJHOAgAFmdjA=
Date: Tue, 31 Dec 2013 01:27:32 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364172F308AA@penmbx01>
References: <1388023041-25785-1-git-send-email-wenyou.yang@atmel.com>
 <20131230120327.GN31886@sirena.org.uk>
In-Reply-To: <20131230120327.GN31886@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Monday, December 30, 2013 8:03 PM
> To: Yang, Wenyou
> Cc: lgirdwood@gmail.com; plagnioj@jcrosoft.com; Ferre, Nicolas; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] regulator: act8865: register all regulators regardless
> of how many are used
> 
> On Thu, Dec 26, 2013 at 09:57:21AM +0800, Wenyou Yang wrote:
> > As Mark pointed out, the driver should register all regulators
> > regardless of how many are used in the system in order to aid diagnostics.
> 
> Thanks for doing this but it doesn't apply against the current code due to
> the fixups from Axel.  Can you please check and resend?
Thanks, I will send a new version.

Happy New Year!

Best Regards,
Wenyou Yang
