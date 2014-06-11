Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbaFKQ4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:56:52 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.162]:6110 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755742AbaFKQ4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:56:50 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-13.tower-39.messagelabs.com!1402505805!10999516!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Jonathan Cameron <jic23@kernel.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH 4/8] iio: Add support for DA9150 GPADC
Thread-Topic: [PATCH 4/8] iio: Add support for DA9150 GPADC
Thread-Index: AQHPhWXnsW9Hzw1urUGbXZZXqpSfwZtsCpYAgAAUd7A=
Date: Wed, 11 Jun 2014 16:56:44 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337A56F5455@SW-EX-MBX01.diasemi.com>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
 <3c1a7551c7deaeccdca731fa95f4349c57e04249.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
 <ba29cc7f-7586-430c-8947-763510e04212@email.android.com>
In-Reply-To: <ba29cc7f-7586-430c-8947-763510e04212@email.android.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5BGuuCX031898

On June 11, 2014 17:35, Jonathon Cameron wrote:

> Hi Adam. Silly question but what are the _ channels?
> 
> I have put in a perhaps optimistic data sheet request via the website, throwing in
> your name. Hope you don't mind!
> 
> Jonathan

Hi Jonathon. Some of the _channels are a different representation of the reading
(e.g. different scale - one would be 0-6V range, and one would be 0-21V for
example). Others provide identical readings to the non _channel but have left
those in to keep the channel numbering sane and easy to reference.

No problem regarding the request.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
