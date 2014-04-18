Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaDRN6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:58:46 -0400
Received: from mail-bl2on0121.outbound.protection.outlook.com ([65.55.169.121]:17767
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751314AbaDRN6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:58:43 -0400
From: <tthayer@altera.com>
To: <linux-can@vger.kernel.org>, <wg@grandegger.com>, <mkl@pengutronix.de>,
        <tglx@linutronix.de>
CC: <socketcan@hartkopp.net>, <anilkumar@ti.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tthayer.linux@gmail.com>
Subject: [PATCHv2] Add support for standard D_CAN module RAM Init Bit
Date: Fri, 18 Apr 2014 09:03:13 -0500
Message-ID: <1397829794-9714-1-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(81542001)(81342001)(92726001)(93916002)(86362001)(2201001)(92566001)(86152002)(62966002)(6806004)(74662001)(16796002)(31966008)(50986999)(74502001)(36756003)(2009001)(4396001)(99396002)(50226001)(48376002)(76482001)(46102001)(42186004)(97736001)(80022001)(80976001)(83072002)(87936001)(77156001)(85852003)(50466002)(44976005)(83322001)(88136002)(87286001)(77982001)(89996001)(84676001)(20776003)(47776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1BFFO11HUB050;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:6CE278D0.AFD2152B.41FC81EA.8CD091B1.200D9;MLV:sfv;PTR:ErrorRetry;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The standard D_CAN module includes the RAM Init bit in one of the 
D_CAN registers. This patch will properly initialize the RAM Init
bit which is self-clearing when the RAM Init is complete.
This patch fixes a boot message reporting an invalid resource as
well as the message saying control memory is not used for raminit.

[PATCHv2] net: c_can: Add support for D_CAN RAM Init bit in D_CAN

