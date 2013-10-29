Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab3J2NAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:00:48 -0400
Received: from muin.pair.com ([209.68.1.55]:62772 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab3J2NAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:00:46 -0400
Message-ID: <526FB17C.3090009@tabi.org>
Date: Tue, 29 Oct 2013 08:00:44 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Firefox/24.0 SeaMonkey/2.21
MIME-Version: 1.0
To: Chen Guangyu-B42378 <B42378@freescale.com>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Huang Shijie-B32955 <B32955@freescale.com>
Subject: Re: [PATCH 2/3] ASoC: fsl_ssi: Add dual fifo mode support
References: <cover.1383047327.git.b42378@freescale.com> <02f8867363ed3038a0a70703856e4b642fef4339.1383047327.git.b42378@freescale.com>,<526FAD41.2000805@tabi.org> <flq2m8se8fxm4icha4yrpcbn.1383051217235@email.android.com>
In-Reply-To: <flq2m8se8fxm4icha4yrpcbn.1383051217235@email.android.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Guangyu-B42378 wrote:
> Without dual fifo support,  handware underrun would occasionally
> occur and then two audio channels would physically swap. This could
> be easily reproduced in low bus frequency situation, while it would
> be better if we enable dual fifo.

Ok.

ACK.
