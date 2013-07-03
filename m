Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab3GCIOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:14:10 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:4207
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757Ab3GCIOH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:14:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh2a8h668h839h93fhd24he5bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>
To: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next arm multi_v7_defconfig: add support for i.MX6 on NFS root
Date: Wed, 3 Jul 2013 10:12:57 +0200
Message-ID: <1372839179-14542-1-git-send-email-vincent.stehle@freescale.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to propose the following two patches, which allow me to boot
next-20130702 with NFS root on an i.MX6 sabre sd:

  [PATCH linux-next 1/2] arm: multi_v7_defconfig: add i.MX serial
  [PATCH linux-next 2/2] arm: multi_v7_defconfig: add support for NFS

Note that at the time of writing, a few other patches are necessary for me as
well:

- i2c-designware: use div_u64 to fix link
  https://lkml.org/lkml/2013/7/2/145

- tick: Prevent uncontrolled switch to oneshot mode
  https://lkml.org/lkml/2013/7/2/270

- tick: Sanitize broadcast control logic
  https://lkml.org/lkml/2013/7/2/272

Best regards,

V.


