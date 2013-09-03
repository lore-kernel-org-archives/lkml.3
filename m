Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab3ICLsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 07:48:31 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:26082
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932597Ab3ICLsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:48:30 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
CC: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 3/3] ipc: Add support for default interrupt mode
Thread-Topic: [PATCH v1 3/3] ipc: Add support for default interrupt mode
Thread-Index: AQHOh03uuA9Kh1W8qkyDIU0IZ4zxipm0KGEA
Date: Tue, 3 Sep 2013 11:48:25 +0000
Message-ID: <1378208904.11730.2.camel@x230>
References: <cover.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
	 <871d1b965914d6c90e698aa67827854e748f18e1.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <871d1b965914d6c90e698aa67827854e748f18e1.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 09583628E0
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(51704005)(199002)(189002)(24454002)(83072001)(51856001)(46102001)(74366001)(4396001)(81542001)(19580395003)(47976001)(50986001)(81342001)(47736001)(49866001)(83322001)(19580405001)(80976001)(63696002)(76482001)(54316002)(56776001)(53806001)(81816001)(54356001)(79102001)(59766001)(77982001)(81686001)(33646001)(47446002)(74502001)(33716001)(76796001)(76786001)(74662001)(31966008)(69226001)(65816001)(74706001)(56816003)(77096001)(74876001)(66066001)(80022001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:209.6.207.143;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF3B0281D1937B40BA8E72CC3EF2E03D@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r83BmdX5013885

On Mon, 2013-07-22 at 19:48 -0700, Kuppuswamy Sathyanarayanan wrote:
> Added intel scu ipc access mode config option.
> 
> Also, This patch adds support to enable ipc command interrupt
> mode by default. This functionality is enabled by following
> config option.
> 
> CONFIG_INTEL_SCU_IPC_INTR_MODE=y

Can you document this in the help text? It's unclear whether people
should enable this option or not.
-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
