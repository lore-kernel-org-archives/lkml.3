Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaICGDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:03:41 -0400
Received: from relmlor4.renesas.com ([210.160.252.174]:15575 "EHLO
	relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754491AbaICGDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:03:39 -0400
X-IronPort-AV: E=Sophos;i="5.04,455,1406559600"; 
   d="scan'208";a="168203444"
Message-ID: <5406AF31.4070906@renesas.com>
Date: Wed, 3 Sep 2014 15:03:29 +0900
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        USB list <linux-usb@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: renesas_usbhs: fix driver dependencies
References: <1601192.oClrOJlUe8@amdc1032> <CAMuHMdVp16nXS1GefyV0OD7Dwewct0UPTEEYLj+GKCrnBxjhLw@mail.gmail.com> <20140901233900.GB15867@verge.net.au>
In-Reply-To: <20140901233900.GB15867@verge.net.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [211.11.155.147]
X-ClientProxiedBy: HKXPR06CA012.apcprd06.prod.outlook.com (10.141.129.42) To
 SINPR06MB330.apcprd06.prod.outlook.com (10.141.110.16)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 032334F434
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019014)(6049001)(6009001)(377454003)(189002)(479174003)(199003)(24454002)(51704005)(74662001)(102836001)(86362001)(33656002)(64126003)(101416001)(23756003)(81342001)(65816999)(83072002)(21056001)(74502001)(85852003)(31966008)(106356001)(4396001)(42186005)(15975445006)(77096002)(90102001)(15202345003)(36756003)(50986999)(80316001)(46102001)(47776003)(79102001)(85306004)(87976001)(19580405001)(95666004)(105586002)(50466002)(107046002)(81542001)(92726001)(20776003)(77982001)(92566001)(65806001)(99396002)(87266999)(19580395003)(76482001)(64706001)(76176999)(83322001)(54356999)(80022001)(66066001)(65956001);DIR:OUT;SFP:1102;SCL:1;SRVR:SINPR06MB330;H:[10.161.20.147];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: renesas.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/02 8:39), Simon Horman wrote:
> On Mon, Sep 01, 2014 at 06:40:50PM +0200, Geert Uytterhoeven wrote:
>> On Mon, Sep 1, 2014 at 4:24 PM, Bartlomiej Zolnierkiewicz
>> <b.zolnierkie@samsung.com> wrote:
>>> Renesas USBHS controller support should be available only on
>>> Renesas ARM SoCs and SuperH architecture.
>>>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> Cc: Simon Horman <horms@verge.net.au>
>>> Cc: Magnus Damm <magnus.damm@gmail.com>
>>> ---
>>> v2:
>>> - s/ARCH_SH/SUPERH/ (thanks to Sergei Shtylyov)
>>
>> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Acked-by: Simon Horman <horms+renesas@verge.net.au>

Acked-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Best regards,
Yoshihiro Shimoda

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
