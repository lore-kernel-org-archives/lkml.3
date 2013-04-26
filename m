Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3DZSzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 14:55:38 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:43226 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab3DZSzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 14:55:36 -0400
MIME-Version: 1.0
In-Reply-To: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
Date: Fri, 26 Apr 2013 11:55:35 -0700
X-Google-Sender-Auth: 8NrTCnp1E8c3PuobuQd9MKCK8HM
Message-ID: <CAPnjgZ1P6dmRB0sO2qBUtd=WBiNcY339NAit2faaotAfEqQDeQ@mail.gmail.com>
Subject: Re: [PATCH v8 0/3] Runtime Interpreted Power Sequences
From: Simon Glass <sjg@chromium.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        lk <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        linux-pm@vger.kernel.org, Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 15, 2012 at 10:38 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Hopefully the final series before the feature gets merged. Anton Vorontsov
> kindly accepted to take it into his tree, so this series is mostly a call for
> acks, tests and reviews notices before the merge window for 3.8 opens. If you
> are interested in seeing this feature, please add your name.
>
> This series also adds an entry for the subsystem into MAINTAINERS, setting me as
> the person in charge.
>
> Changes from v7:
> - fix bug reported by Tony Prisk
> - add MAINTAINERS entry
>
> Alexandre Courbot (3):
>   Runtime Interpreted Power Sequences
>   pwm_backlight: use power sequences
>   Take maintainership of power sequences

Did this actually land? I can't see it in linux-next.

Regards,
Simon
