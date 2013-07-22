Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3GVBTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:19:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55154 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab3GVBTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:19:32 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: RE: [PATCH 2/3] gpio: add LP3943 I2C GPIO expander driver
Thread-Topic: [PATCH 2/3] gpio: add LP3943 I2C GPIO expander driver
Thread-Index: Ac6BzFs3MaNz/ZBDRsOLUZtrVGmnRwDd/8cAAEwq8SA=
Date: Mon, 22 Jul 2013 01:19:25 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E83189@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E815CE@DQHE06.ent.ti.com>
 <CACRpkdYVCrz_30HsX_4C5aFR0c3K4OzTXSo7gx_W39Ukpg8cpw@mail.gmail.com>
In-Reply-To: <CACRpkdYVCrz_30HsX_4C5aFR0c3K4OzTXSo7gx_W39Ukpg8cpw@mail.gmail.com>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Thanks for both of GPIO patch reviews.
I'll fix them.

> I forgot one thing:
> 
> On Tue, Jul 16, 2013 at 4:38 AM, Kim, Milo <Milo.Kim@ti.com> wrote:
> 
> > +static int lp3943_gpio_probe(struct platform_device *pdev)
> > +{
> > +       struct lp3943 *l = dev_get_drvdata(pdev->dev.parent);
> > +       struct lp3943_gpio *lg;
> > +       int ret;
> 
> This is where I want you to assign to a member of struct
> lp3943 another u16 mask which tells which lines are
> actually available for GPIO, and you should also add code to
> make sure that lines that are not available fail gpio_request().
> 
> This configuration can probably be read out from the device
> tree if you add the compatible node to the MFD cell when
> registering it.
> 
> Yours,
> Linus Walleij

Regards,
Milo
