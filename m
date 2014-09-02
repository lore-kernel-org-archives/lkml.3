Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaIBG4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 02:56:12 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:50661 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaIBG4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 02:56:10 -0400
MIME-Version: 1.0
In-Reply-To: <7567220.FuQYiIRUM7@vostro.rjw.lan>
References: <1409318001-27586-1-git-send-email-geert+renesas@glider.be>
	<7567220.FuQYiIRUM7@vostro.rjw.lan>
Date: Tue, 2 Sep 2014 08:56:08 +0200
X-Google-Sender-Auth: RzJb36Dz6QuRDuAJ5MFUufSbqCs
Message-ID: <CAMuHMdU7XSaCY11jEx2Cq=zxYLY5T3n=GaRdXxf7u=H9--T_gA@mail.gmail.com>
Subject: Re: [PATCH] PM / Domains: Make generic_pm_domain.name const
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Tue, Sep 2, 2014 at 1:50 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> I'm going to apply this one.  Does anything depend on it?

Thanks. So far nothing depends on it.

>> ---
>>  include/linux/pm_domain.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
>> index 7c1d252b20c0..ebc4c76ffb73 100644
>> --- a/include/linux/pm_domain.h
>> +++ b/include/linux/pm_domain.h
>> @@ -60,7 +60,7 @@ struct generic_pm_domain {
>>       struct mutex lock;
>>       struct dev_power_governor *gov;
>>       struct work_struct power_off_work;
>> -     char *name;
>> +     const char *name;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
