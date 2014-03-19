Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaCSFkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 01:40:49 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:58136 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaCSFkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 01:40:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJVviZYpzoPb-sHeD3T3h7km2+3QNEJGLT3zO2dFhCV4w@mail.gmail.com>
References: <1395168169-28978-1-git-send-email-jaswinder.singh@linaro.org>
	<1395168355-29157-1-git-send-email-jaswinder.singh@linaro.org>
	<CAL_JsqJVviZYpzoPb-sHeD3T3h7km2+3QNEJGLT3zO2dFhCV4w@mail.gmail.com>
Date: Wed, 19 Mar 2014 11:10:47 +0530
Message-ID: <CAJe_Zhc7r9gTjc7uA-Z0RTjFSq6Rscxve+KF1T_qd31oeS6+_w@mail.gmail.com>
Subject: Re: [PATCHv4 3/5] mailbox: pl320: Introduce common API driver
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "s-anna@ti.com" <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        "omar.ramirez@copitl.com" <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 00:40, Rob Herring <robherring2@gmail.com> wrote:
> On Tue, Mar 18, 2014 at 1:45 PM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>> Convert the PL320 controller driver to work with the common
>> mailbox API. Also convert the only user of PL320, highbank-cpufreq.c
>> to work with thee API. Drop the obsoleted driver pl320-ipc.c
>>
>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>> ---
>>  drivers/cpufreq/highbank-cpufreq.c |  24 ++++-
>>  drivers/mailbox/Makefile           |   2 +-
>>  drivers/mailbox/pl320-ipc.c        | 198 ----------------------------------
>>  drivers/mailbox/pl320.c            | 214 +++++++++++++++++++++++++++++++++++++
>
> Would you mind resending with rename detection enabled.
>
> You can make that the default by adding this to your config:
>
> [diff]
>         renames = true
>
The driver isn't just renamed. The new driver is quite different from
original. So '-M' option to git format-patch doesn't make it simpler.
Btw I do have "git config --global diff.renames true" as well.

-Jassi
