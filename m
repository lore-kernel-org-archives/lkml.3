Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaGCKX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:23:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50241 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489AbaGCJU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:20:57 -0400
Message-ID: <1404379248.18039.31.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 0/4] Add reset controllers for STiH407 SoC
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Lee Jones <lee.jones@linaro.org>, Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, patrice.chotard@st.com,
        devicetree@vger.kernel.org
Date: Thu, 03 Jul 2014 11:20:48 +0200
In-Reply-To: <53B50EFD.2070007@st.com>
References: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
	 <1404317194.4109.13.camel@paszta.hi.pengutronix.de>
	 <20140702165924.GB17665@lee--X1> <53B50EFD.2070007@st.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Donnerstag, den 03.07.2014, 10:06 +0200 schrieb Maxime Coquelin:
> I will queue patch 4 to STi DT branch for v3.17.
> For now, no nodes uses reset for STiH407, so we don't need the 
> dt-bindings header file in the STi tree.
> 
> If we have a DT node using a reset line before my pull-request, I might 
> have to integrate the series in the STi DT branch.
> Philipp, does that sound reasonable?

Patch 4 depends on patch 1 for the header. My tree is still empty, how
about I take the first two, and you merge that branch and then take 3
and 4 on top?

    git://git.pengutronix.de/git/pza/linux.git reset/for_v3.17

Lee, shall I also add your Ack to the documentation patch?

regards
Philipp

