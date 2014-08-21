Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaHUTas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:30:48 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:54191 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbaHUTap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:30:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140821044230.GA14609@roeck-us.net>
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
	<1408495538-27480-3-git-send-email-linux@roeck-us.net>
	<CAD=FV=Va8UrpDCLjFQJ6j-K0C3v7NPfifaJGtReCkUEu3x0mLg@mail.gmail.com>
	<20140821044230.GA14609@roeck-us.net>
Date: Thu, 21 Aug 2014 12:30:44 -0700
X-Google-Sender-Auth: ckNMrYFsJTlfoz1xgcxefww0KEY
Message-ID: <CAD=FV=XMBegDcPWM+sG4S64ZC6KEzKA-ykpEJrcGo2db+P0VLg@mail.gmail.com>
Subject: Re: [PATCH v7 02/11] power/restart: Call machine_restart instead of arm_pm_restart
From: Doug Anderson <dianders@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Russell King <linux@arm.linux.org.uk>, Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,

On Wed, Aug 20, 2014 at 9:42 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Wed, Aug 20, 2014 at 09:10:31PM -0700, Doug Anderson wrote:
>> Guenter,
>>
>> On Tue, Aug 19, 2014 at 5:45 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> > machine_restart is supported on non-ARM platforms, and and ultimately calls
>> > arm_pm_restart, so dont call arm_pm_restart directly but use the more
>> > generic function.
>> >
>> > Cc: Russell King <linux@arm.linux.org.uk>
>>
>> Do you need to submit this to his patch tracker to get him to pick it
>> up?  How are you envisioning that this series land?  It crosses a lot
>> of boundaries so I guess will need a reasonable amount of coordination
>> between maintainers...
>>
>>
> If I get an Acked-by: from all maintainers, I could send a pull request
> to Linus directly. How do I send a patch to Russell's patch tracker ?
> I thought I copied all mailing lists suggested by get_maintainer.pl,
> but maybe I missed one.

Ah, OK.  Perhaps it's best to ignore me, then.  ;)  FYI: Russell's
Patch System is at <http://www.arm.linux.org.uk/developer/patches/>
and is used for getting individual patches into branches maintained by
Russel.  If you're just going to send a pull request for the series
then I don't think you need it.
