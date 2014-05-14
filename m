Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaENJQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:16:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50216 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaENJQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:16:24 -0400
Message-ID: <1400058953.13056.2.camel@paszta.hi.pengutronix.de>
Subject: Re: [STLinux Kernel] [PATCH v4 2/7] driver: reset: sti: add keyscan
 for stih415
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        olof Johansson <olof@lixom.net>, devicetree@vger.kernel.org,
        kernel@stlinux.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        linux-input@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Giuseppe Condorelli <giuseppe.condorelli@st.com>
Date: Wed, 14 May 2014 11:15:53 +0200
In-Reply-To: <53732EAB.1050709@st.com>
References: <1397228856-9218-1-git-send-email-gabriel.fernandez@linaro.org>
	 <1397228856-9218-3-git-send-email-gabriel.fernandez@linaro.org>
	 <53732EAB.1050709@st.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Am Mittwoch, den 14.05.2014, 10:51 +0200 schrieb Maxime Coquelin:
> Hi Philipp,
> 
> 	I am preparing the arm_soc pull request for STi platforms.
> 
> 	In this series, there are DT patches depending on this reset patch 
> (same for patch 3).
> 
> 	Can I queue theses two reset patches in my pull request for arm_soc to 
> avoid compilation breakage?

Yes, please do. For both of them, feel free to add my
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

best regards
Philipp

