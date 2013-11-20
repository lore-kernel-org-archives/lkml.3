Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3KTXws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:52:48 -0500
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:50839
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754975Ab3KTXwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:52:43 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "tiwai@suse.de" <tiwai@suse.de>
CC: "ibm-acpi-devel@lists.sourceforge.net" 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "ibm-acpi@hmh.eng.br" <ibm-acpi@hmh.eng.br>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thinkpad_acpi: Fix build error when
 CONFIG_SND_MAX_CARDS > 32
Thread-Topic: [PATCH] thinkpad_acpi: Fix build error when
 CONFIG_SND_MAX_CARDS > 32
Thread-Index: AQHO0MHYiEs8kUUCGEed00HqjQ3J0Jou9ZgA
Date: Wed, 20 Nov 2013 23:52:22 +0000
Message-ID: <1384991542.20536.7.camel@x230>
References: <1382623592-31690-1-git-send-email-tiwai@suse.de>
In-Reply-To: <1382623592-31690-1-git-send-email-tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(59766001)(69226001)(74876001)(76786001)(76796001)(83072001)(77982001)(33646001)(74706001)(81816001)(56816003)(85306002)(56776001)(77096001)(33716001)(54316002)(50986001)(19580395003)(47976001)(81686001)(2656002)(74662001)(81342001)(74366001)(83322001)(19580405001)(81542001)(31966008)(47736001)(49866001)(65816001)(80022001)(558084003)(87266001)(4396001)(47446002)(80976001)(74502001)(54356001)(79102001)(87936001)(51856001)(63696002)(76482001)(46102001)(53806001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB422;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks.
-- 
Matthew Garrett <matthew.garrett@nebula.com>
