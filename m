Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaBXQzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:55:48 -0500
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:36438
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752464AbaBXQzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:55:33 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "cminyard@mvista.com" <cminyard@mvista.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "rja@sgi.com" <rja@sgi.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH 1/3] ipmi: Turn off default probing of interfaces
Thread-Topic: [PATCH 1/3] ipmi: Turn off default probing of interfaces
Thread-Index: AQHPMQeAsKLobApQbEiVh76YEo0G8JrEn8gAgAAAlYA=
Date: Mon, 24 Feb 2014 16:55:25 +0000
Message-ID: <1393260925.20109.50.camel@x230>
References: <1393208616-16500-1-git-send-email-minyard@acm.org>
	 <1393208616-16500-2-git-send-email-minyard@acm.org>
	 <20140224165320.GA26479@core.coreip.homeip.net>
In-Reply-To: <20140224165320.GA26479@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0132C558ED
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(377424004)(189002)(199002)(24454002)(33716001)(74706001)(47736001)(50986001)(47976001)(95666003)(49866001)(74876001)(4396001)(63696002)(80022001)(65816001)(74662001)(74502001)(31966008)(47446002)(33646001)(87266001)(79102001)(2656002)(92726001)(19580395003)(56776001)(59766001)(77982001)(74366001)(83322001)(85306002)(69226001)(81342001)(81542001)(93136001)(87936001)(93516002)(94946001)(76482001)(94316002)(19580405001)(56816005)(90146001)(80976001)(54316002)(85852003)(83072002)(53806001)(51856001)(76796001)(46102001)(77096001)(54356001)(558084003)(81816001)(95416001)(86362001)(81686001)(76786001)(92566001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR05MB753;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:1FCFF9B5.7EA8470A.32D6038B.16E22D91.20097;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4AB781E93E24E94EB3A0D96C81426095@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1OGttDb016008

On Mon, 2014-02-24 at 08:53 -0800, Dmitry Torokhov wrote:

> Would not
> 
> static bool          si_trydefaults = IS_ENABLED(CONFIG_IPMI_SI_PROBE_DEFAULTS);
> 
> work better here?

Yes, it would. Sorry, I should have thought of that.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
