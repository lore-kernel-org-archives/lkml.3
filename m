Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaEVEFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:05:55 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:58140 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaEVEFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:05:53 -0400
MIME-Version: 1.0
In-Reply-To: <5258228.rMTDJps2Fm@vostro.rjw.lan>
References: <7cb6e0e039e0935e37c81d0f23d26b0b81ad8cda.1400597170.git.viresh.kumar@linaro.org>
	<1555967.8fxByr2j83@vostro.rjw.lan>
	<CAKohponU2feK9+9sUn4tu0t4fhwSy6PZuaAO3zkF7qRejCwM1Q@mail.gmail.com>
	<5258228.rMTDJps2Fm@vostro.rjw.lan>
Date: Thu, 22 May 2014 09:35:52 +0530
Message-ID: <CAKohpokovwiU2DF=BJQsfZR3E_c-w9t5yV1HE-Ji88QziTWnUA@mail.gmail.com>
Subject: Re: [PATCH V5] PM/OPP: discard duplicate OPPs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>, Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Chander Kashyap <k.chander@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 May 2014 05:18, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> The case in which we want to return 0.  Never mind, it's OK.

Ahh yes, It was wrong earlier and fixed during this patch only :)

> The parens are still not necessary, though.

Already got rid of them and so didn't bother replying :)
