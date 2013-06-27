Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab3F0TUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:20:11 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53469 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab3F0TUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:20:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Naresh Bhat <naresh.bhat@linaro.org>
Cc: linux-acpi@vger.kernel.org, len.brown@intel.com, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/fan: Initialize acpi_state variable
Date: Thu, 27 Jun 2013 21:29:39 +0200
Message-ID: <1990033.Jb3giURhtn@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAFoFrHaUbjHbvDDVO0+1j4WSTdhdrWF64MrNvzKNJXaLKSv_jw@mail.gmail.com>
References: <1372331314-31010-1-git-send-email-naresh.bhat@linaro.org> <6743122.cV0P3hQa28@vostro.rjw.lan> <CAFoFrHaUbjHbvDDVO0+1j4WSTdhdrWF64MrNvzKNJXaLKSv_jw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 27, 2013 06:37:35 PM Naresh Bhat wrote:
> Hi Rafael,
> 
> You mean I need to initialize using ACPI_STATE_D0 ? and resend the patch ?

Yes, please.

Although this is a false positive anyway ...

Thanks,
Rafael


> On 27 June 2013 17:58, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, June 27, 2013 04:38:34 PM naresh.bhat@linaro.org wrote:
> >> From: Naresh Bhat <naresh.bhat@linaro.org>
> >>
> >>   CC      drivers/acpi/fan.o
> >> drivers/acpi/fan.c: In function ‘fan_get_cur_state’:
> >> drivers/acpi/fan.c:96:9: warning: ‘acpi_state’ may be used uninitialized in this function [-Wuninitialized]
> >> ---
> >>  drivers/acpi/fan.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> >> index f815da8..f61f7fd 100644
> >> --- a/drivers/acpi/fan.c
> >> +++ b/drivers/acpi/fan.c
> >> @@ -84,7 +84,7 @@ static int fan_get_cur_state(struct thermal_cooling_device *cdev, unsigned long
> >>  {
> >>       struct acpi_device *device = cdev->devdata;
> >>       int result;
> >> -     int acpi_state;
> >> +     int acpi_state = 0;
> >
> > Please use an appropriate symbol here.
> >
> >>
> >>       if (!device)
> >>               return -EINVAL;
> >>
> >
> > Thanks,
> > Rafael
> >
> >
> > --
> > I speak only for myself.
> > Rafael J. Wysocki, Intel Open Source Technology Center.
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
