Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaHYDff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 23:35:35 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:59056
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753805AbaHYDfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 23:35:33 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <nicoleotsuka@gmail.com>, <timur@tabi.org>,
        <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>
CC: <galak@codeaurora.org>, <mark.rutland@arm.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 0/4] ASoC: Convert to use regmap framework's endianness method.
Date: Mon, 25 Aug 2014 11:30:58 +0800
Message-ID: <1408937462-18727-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(83322001)(46102001)(85306004)(104016003)(36756003)(31966008)(4396001)(68736004)(90102001)(76482001)(77156001)(105606002)(229853001)(79102001)(106466001)(81542001)(107046002)(104166001)(69596002)(50226001)(81156004)(48376002)(86362001)(97736001)(89996001)(83072002)(21056001)(88136002)(87286001)(92566001)(92726001)(102836001)(80022001)(50466002)(77982001)(84676001)(50986999)(44976005)(64706001)(81342001)(2201001)(20776003)(74662001)(85852003)(95666004)(99396002)(74502001)(47776003)(19580395003)(87936001)(6806004)(26826002)(62966002)(93916002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0623;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03142412E2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in V3:
- Delete 'ASoC: fsl-sai: rename big_endian_data to is_msb_first.' patch.


Changes in V2:
- Modified the regmap config to const type.
- Added ASRC patch.
- Followed Rutland's advice.




Xiubo Li (4):
  ASoC: fsl-asrc: Convert to use regmap framework's endianness method.
  ASoC: fsl-esai: Convert to use regmap framework's endianness method.
  ASoC: fsl-spdif: Convert to use regmap framework's endianness method.
  ASoC: fsl-sai: Convert to use regmap framework's endianness method.

 Documentation/devicetree/bindings/sound/fsl-sai.txt | 7 +++----
 sound/soc/fsl/fsl_asrc.c                            | 6 +-----
 sound/soc/fsl/fsl_esai.c                            | 5 +----
 sound/soc/fsl/fsl_sai.c                             | 6 +-----
 sound/soc/fsl/fsl_sai.h                             | 1 -
 sound/soc/fsl/fsl_spdif.c                           | 5 +----
 6 files changed, 7 insertions(+), 23 deletions(-)

-- 
1.8.5

