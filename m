Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab3FZFio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:38:44 -0400
Received: from [207.46.163.212] ([207.46.163.212]:28007 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751652Ab3FZFil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:38:41 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Darren Hart <dvhart@linux.intel.com>
CC: Olof Johansson <olof@lixom.net>, "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "peter.p.waskiewicz.jr@intel.com" <peter.p.waskiewicz.jr@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
	<andriy.shevchenko@linux.intel.com>,
        "danders@circuitco.com" <danders@circuitco.com>,
        "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
Thread-Topic: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
Thread-Index: AQHOcg//k4Oo/fSkBUqc5+pwXHA5uZlHX0AAgAAMBgCAAAKYgIAACwsAgAABLAA=
Date: Wed, 26 Jun 2013 05:36:29 +0000
Message-ID: <1372224988.9179.5.camel@x230>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
	 <20130626040026.GA23621@quad.lixom.net>
	 <1372221808.8177.52.camel@envy.home> <1372222365.9179.4.camel@x230>
	 <1372224736.8177.63.camel@envy.home>
In-Reply-To: <1372224736.8177.63.camel@envy.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-prvs: 08897B549D
x-forefront-antispam-report: SFV:NSPM;SFS:(51704005)(377424004)(24454002)(189002)(199002)(4396001)(50986001)(47976001)(54356001)(59766001)(69226001)(74876001)(65816001)(77982001)(46102001)(63696002)(76482001)(56776001)(54316002)(51856001)(47736001)(49866001)(80022001)(81342001)(79102001)(81542001)(74366001)(16406001)(31966008)(33646001)(33716001)(76796001)(47446002)(74662001)(74502001)(53806001)(56816003)(77096001)(74706001)(76786001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB224;H:BY2PR05MB222.namprd05.prod.outlook.com;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C06A9FFF7010348A32036CB5312020B@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5Q5crf9003645

On Tue, 2013-06-25 at 22:32 -0700, Darren Hart wrote:

> are all board-specific. They map GPIO to their fixed functions and
> provide an API for board-specific queries (minnowboard.c), they provide
> example uses (minnowboard-gpio and minnowboard-keys) which aid in
> experimentation and the development of new drivers.
> 
> Which of these make sense as ACPI devices in your opinion?

Does the firmware contain a corresponding ACPI device with a specific
_HID that defines the programming model? If so, it should have an ACPI
driver. If not, it shouldn't.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
