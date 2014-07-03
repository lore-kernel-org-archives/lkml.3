Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbaGCNcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:32:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41867 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbaGCNcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:32:35 -0400
Message-ID: <1404394341.18039.35.camel@paszta.hi.pengutronix.de>
Subject: [GIT PULL] STiH407 reset controller support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Lee Jones <lee.jones@linaro.org>, Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, patrice.chotard@st.com,
        devicetree@vger.kernel.org
Date: Thu, 03 Jul 2014 15:32:21 +0200
In-Reply-To: <20140703094001.GB32208@lee--X1>
References: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
	 <1404317194.4109.13.camel@paszta.hi.pengutronix.de>
	 <20140702165924.GB17665@lee--X1> <53B50EFD.2070007@st.com>
	 <1404379248.18039.31.camel@paszta.hi.pengutronix.de>
	 <20140703094001.GB32208@lee--X1>
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

Hi Maxime,

Am Donnerstag, den 03.07.2014, 10:40 +0100 schrieb Lee Jones:
> On Thu, 03 Jul 2014, Philipp Zabel wrote:
> > Patch 4 depends on patch 1 for the header. My tree is still empty, how
> > about I take the first two, and you merge that branch and then take 3
> > and 4 on top?
> 
> That approach sounds reasonable.  Once you've applied the patches can
> you tag the branch and provide Maxime with a pull-request please
> Philipp?

The following changes since commit
7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.pengutronix.de/git/pza/linux.git tags/reset-for-sti-3.17

for you to fetch changes up to d29d2a38d1c1b21730487e991183ffe7e16e1ef5:

  reset: sti: Document sti-picophyreset controllers bindings.
(2014-07-03 14:58:22 +0200)

----------------------------------------------------------------
STiH407 reset controller support

----------------------------------------------------------------
Peter Griffin (2):
      reset: stih407: Add softreset, powerdown and picophy controllers
      reset: sti: Document sti-picophyreset controllers bindings.

 .../bindings/reset/st,sti-picophyreset.txt         |  42 ++++++
 drivers/reset/sti/Kconfig                          |   4 +
 drivers/reset/sti/Makefile                         |   1 +
 drivers/reset/sti/reset-stih407.c                  | 158
+++++++++++++++++++++
 .../dt-bindings/reset-controller/stih407-resets.h  |  61 ++++++++
 5 files changed, 266 insertions(+)
 create mode 100644
Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
 create mode 100644 drivers/reset/sti/reset-stih407.c
 create mode 100644
include/dt-bindings/reset-controller/stih407-resets.h

regards
Philipp

