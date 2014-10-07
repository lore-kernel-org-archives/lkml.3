Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaJGNXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:23:49 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:60398 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753332AbaJGNXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:23:45 -0400
From: Seraphin Bonnaffe <seraphin.bonnaffe@st.com>
To: <b29396@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lee.jones@linaro.org>, <maxime.coquelin@st.com>
Cc: <sameo@linux.intel.com>, <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <arnd@arndb.de>, <seraphin.bonnaffe@st.com>
Subject: [RFC PATCH 0/2] mfd: syscon: declare holes in syscon register maps
Date: Tue, 7 Oct 2014 15:22:26 +0200
Message-ID: <1412688148-20835-1-git-send-email-seraphin.bonnaffe@st.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <54244655.1090801@st.com>
References: <54244655.1090801@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-07_05:2014-10-07,2014-10-07,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In reply to mail: Holes management in syscon driver. 

Hi Dong, Maxime, Lee, all,

Regmap also offers .rd_table and .wr_table structures that can be used to
specify valid ranges within agiven regmap configuration.

This patch uses these structures to declare holes in a syscon instance.
It takes the description from DT, and fills in the structures accordingly.

Can I have your opinion on this implementation ?

Thanks and Regards,
Seraphin

Seraphin Bonnaffe (2):
  mfd: syscon: Document new DT binding "holes"
  mfd: syscon: specify rd_table and wr_table from DT

 Documentation/devicetree/bindings/mfd/syscon.txt |  5 ++++
 drivers/mfd/syscon.c                             | 35 ++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

-- 
1.9.1

