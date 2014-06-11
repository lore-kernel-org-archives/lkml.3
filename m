Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbaFKNRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:17:25 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.176]:49359 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbaFKNRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:17:22 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-3.tower-38.messagelabs.com!1402492637!23668566!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Rob Herring <robherring2@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        "Lee Jones" <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Jonathan Cameron" <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: RE: [PATCH 8/8] DT: Add vendor prefix for Dialog Semiconductor Ltd.
Thread-Topic: [PATCH 8/8] DT: Add vendor prefix for Dialog Semiconductor Ltd.
Thread-Index: AQHPhWXsl+BblB/jGkWYvkOE3dcBh5trwFiAgAAJgQCAABmYMA==
Date: Wed, 11 Jun 2014 13:17:15 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337A56F53A6@SW-EX-MBX01.diasemi.com>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
	<bf4b6d7b061e66d3ca7f3dd44319b9e26ae7103f.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
	<CAMuHMdWirVk+jrz40yw4=zAOFH6VTX9CXcpO01e0rK8S8VGGHw@mail.gmail.com>
 <CAL_JsqK0RqYuZ8YB1sBZK7hMXvp6oEPfAu11m95F61_kGV3Ptg@mail.gmail.com>
In-Reply-To: <CAL_JsqK0RqYuZ8YB1sBZK7hMXvp6oEPfAu11m95F61_kGV3Ptg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5BDHUvo030408

> On Wed, Jun 11, 2014 at 13:43, Rob Herring wrote:
> 
> dlg is the correct one and seems to be the most widely used, so we
> should go with that and mark the others deprecated.
> 
> diasemi is documented for the da9210, but not used anywhere.
> 
> There appears to be 2 different da9053 bindings. I'd guess the dialog
> variant used on 2 i.MX boards is not used. Other i.MX boards use the
> dlg version. I'm not sure what is going on with da9055. Please sort
> these out.
> 

The intention is to update the other Dialog drivers after we've agreed this
prefix. With regards to da9055, what's the issue here as I believe that uses
the 'dlg' prefix already?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
