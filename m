Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017Ab3ICMIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:08:43 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:34790
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752764Ab3ICMIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:08:41 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Jerome Meinke <jerome.meinke@gmail.com>
CC: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jerome Meinke <meinkej@informatik.uni-freiburg.de>
Subject: Re: [PATCH 1/1] amilo-rfkill: Enable using amilo-rfkill with the
 FSC Amilo L1310.
Thread-Topic: [PATCH 1/1] amilo-rfkill: Enable using amilo-rfkill with the
 FSC Amilo L1310.
Thread-Index: AQHOnO7+UyFJXLMjFUOAqywwsfRnlpm0AqiA
Date: Tue, 3 Sep 2013 12:08:38 +0000
Message-ID: <1378210093.11730.9.camel@x230>
References: <1376925345-6687-1-git-send-email-meinkej@informatik.uni-freiburg.de>
In-Reply-To: <1376925345-6687-1-git-send-email-meinkej@informatik.uni-freiburg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5cb2:ef69:974c:c68a]
x-forefront-prvs: 09583628E0
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(189002)(199002)(80022001)(81686001)(79102001)(59766001)(77982001)(65816001)(63696002)(80976001)(56776001)(54316002)(77096001)(76482001)(54356001)(53806001)(81816001)(76786001)(33646001)(76796001)(69226001)(33716001)(56816003)(81342001)(47736001)(4396001)(74706001)(31966008)(81542001)(49866001)(74876001)(74662001)(50986001)(47976001)(558084003)(74502001)(47446002)(83072001)(74366001)(46102001)(19580405001)(83322001)(51856001)(19580395003)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5cb2:ef69:974c:c68a;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <89472A52FC6A794DB00D03FBFC4079AA@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r83C8lhw013955

On Mon, 2013-08-19 at 17:15 +0200, Jerome Meinke wrote:
> This change extends the amilo_rfkill_id_table[] with the
> DMI_BOARD_NAME information of the Amilo L1310, so that the wifi device
> can be switched on.

Applied, thanks.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
