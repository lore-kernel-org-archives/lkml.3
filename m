Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3LARTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 12:19:41 -0500
Received: from gloria.sntech.de ([95.129.55.99]:34234 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab3LARTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 12:19:39 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH v2 2/2] rtc: add hym8563 rtc-driver
Date: Sun, 1 Dec 2013 18:19:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>
References: <201312011437.47432.heiko@sntech.de> <201312011439.45417.heiko@sntech.de> <CAFLxGvz6ZYHaDJqc6LPwtPsLUaLuEwSEQaJLZ-hV1m8PxruOow@mail.gmail.com>
In-Reply-To: <CAFLxGvz6ZYHaDJqc6LPwtPsLUaLuEwSEQaJLZ-hV1m8PxruOow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201312011819.26005.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 1. Dezember 2013, 15:38:40 schrieb Richard Weinberger:
> On Sun, Dec 1, 2013 at 2:39 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > +static int hym8563_probe(struct i2c_client *client,
> > +                        const struct i2c_device_id *id)
> > +{
> > +       struct hym8563 *hym8563;
> > +       int ret, gpio_int;
> > +
> > +       hym8563 = devm_kzalloc(&client->dev, sizeof(hym8563),
> > GFP_KERNEL);
> 
> Shouldn't this be sizeof(*hym8563)?

you're right of course, thanks for catching the missing "*", I'll send a v3 
shortly.


Heiko
