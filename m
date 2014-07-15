Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbaGONYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:24:37 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59624 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825AbaGONYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:24:35 -0400
MIME-Version: 1.0
In-Reply-To: <2350821.Beygah9hYC@vostro.rjw.lan>
References: <1405171762-31119-1-git-send-email-meraj.enigma@gmail.com>
 <CAHu9=sPxG49pCn10WTErHEV3ZZSF70+7ekZWJ-1+dd3Df8i8Wg@mail.gmail.com> <2350821.Beygah9hYC@vostro.rjw.lan>
From: Mohammad Merajul Islam Molla <meraj.enigma@gmail.com>
Date: Tue, 15 Jul 2014 19:24:14 +0600
Message-ID: <CAHu9=sNfVU3fwZjVwLK6qPEgcwrdkDegsTQfUgUTi6qNhBUwcw@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: fix permission for driver name sysfs node
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. Its not actually :).

On Tue, Jul 15, 2014 at 6:28 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, July 15, 2014 11:16:40 AM Mohammad Merajul Islam Molla wrote:
>> Hi Rafael/Daniel,
>>
>> Did you get a chance to review the patch?
>
> We will review it.  Why is this urgent?
>
> Rafael
>
>
>> On Sat, Jul 12, 2014 at 7:29 PM, Mohammad Merajul Islam Molla
>> <meraj.enigma@gmail.com> wrote:
>> > cpuidle driver name sysfs node is read-only. So permission should be 0444.
>> >
>> > Signed-off-by: Mohammad Merajul Islam Molla <meraj.enigma@gmail.com>
>> > ---
>> >  drivers/cpuidle/sysfs.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
>> > index efe2f17..97c5903 100644
>> > --- a/drivers/cpuidle/sysfs.c
>> > +++ b/drivers/cpuidle/sysfs.c
>> > @@ -445,7 +445,7 @@ static void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
>> >
>> >  #define define_one_driver_ro(_name, show)                       \
>> >         static struct cpuidle_driver_attr attr_driver_##_name = \
>> > -               __ATTR(_name, 0644, show, NULL)
>> > +               __ATTR(_name, 0444, show, NULL)
>> >
>> >  struct cpuidle_driver_kobj {
>> >         struct cpuidle_driver *drv;
>> > --
>> > 1.9.1
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
