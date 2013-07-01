Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3GANt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:49:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56074 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab3GANtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:49:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Naresh Bhat <naresh.bhat@linaro.org>
Cc: linux-acpi@vger.kernel.org, len.brown@intel.com,
        Patch Tracking <patches@linaro.org>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/fan: Initialize acpi_state variable
Date: Mon, 01 Jul 2013 15:59:28 +0200
Message-ID: <4129319.59EevnP3PH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAFoFrHa_XsKaWDag_k3o_Lgizsf+qZUYPjBn9pvWSe83BY8sOg@mail.gmail.com>
References: <1372362463-4186-1-git-send-email-naresh.bhat@linaro.org> <CAFoFrHa_XsKaWDag_k3o_Lgizsf+qZUYPjBn9pvWSe83BY8sOg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 01, 2013 05:31:46 PM Naresh Bhat wrote:
> Hi Rafeal,
> 
> I appreciate if you give any feedback on the provided patch.

The patch is OK, but please add your sign-off.

Thanks,
Rafael


> On 28 June 2013 01:17,  <naresh.bhat@linaro.org> wrote:
> > From: Naresh Bhat <naresh.bhat@linaro.org>
> >
> >   CC      drivers/acpi/fan.o
> > drivers/acpi/fan.c: In function ‘fan_get_cur_state’:
> > drivers/acpi/fan.c:96:9: warning: ‘acpi_state’ may be used uninitialized in this function [-Wuninitialized]
> > ---
> >  drivers/acpi/fan.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> > index f815da8..f961435 100644
> > --- a/drivers/acpi/fan.c
> > +++ b/drivers/acpi/fan.c
> > @@ -84,7 +84,7 @@ static int fan_get_cur_state(struct thermal_cooling_device *cdev, unsigned long
> >  {
> >         struct acpi_device *device = cdev->devdata;
> >         int result;
> > -       int acpi_state;
> > +       int acpi_state = ACPI_STATE_D0;
> >
> >         if (!device)
> >                 return -EINVAL;
> > --
> > 1.7.9.5
> >
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
