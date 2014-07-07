Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaGGSok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:44:40 -0400
Received: from 8.mo5.mail-out.ovh.net ([178.32.116.78]:58670 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751435AbaGGSoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:44:39 -0400
X-Greylist: delayed 890 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2014 14:44:38 EDT
Date: Mon, 7 Jul 2014 20:42:39 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux@maxim.org.za, Nicolas FERRE <nicolas.ferre@atmel.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com, devicetree@vger.kernel.org,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/18] AT91: Call at91_register_devices in the board files
Message-ID: <20140707184239.GI9558@ns203013.ovh.net>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404396906-25194-15-git-send-email-maxime.ripard@free-electrons.com>
 <D103F102-4B04-4CC6-8F20-58CEB0EC8E36@jcrosoft.com>
 <20140703145222.GE31996@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703145222.GE31996@lukather>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 16840929332136291261
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:52 Thu 03 Jul     , Maxime Ripard wrote:
> Hi,
> 
> On Thu, Jul 03, 2014 at 10:29:58PM +0800, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > no do this at SoC level
> 
> Since it has to be done at init_machine, I don't see any other easy
> way to do this at the SoC level.
> 
> What is your suggestion?

do it earlier as there is not driver it will not change anything
