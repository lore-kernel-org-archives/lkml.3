Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148AbaEGNgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:36:15 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:55511 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461AbaEGNgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:36:10 -0400
MIME-Version: 1.0
In-Reply-To: <536A3654.20201@semaphore.gr>
References: <535AC247.3070907@semaphore.gr>
	<5369220A.3030207@semaphore.gr>
	<CAKohpo=3_7G+3bMF2CpWgZXvktdXBkCi4-tCxogwGcvvEEh18w@mail.gmail.com>
	<4469396.zveA7sC36d@vostro.rjw.lan>
	<536A3654.20201@semaphore.gr>
Date: Wed, 7 May 2014 19:06:09 +0530
Message-ID: <CAKohpokLnseVjuWybVTJG5v3-ATpXXbMccE+CscXGyGUnr13yA@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] Introduce new cpufreq helper macros
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Simon Horman <horms@verge.net.au>, Sekhar Nori <nsekhar@ti.com>,
        Samuel Ortiz <samuel@sortiz.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2014 19:04, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Do you want me to resend the entire patch set or only patch 1/8?

Probably a new patch which would make it inline that's it. I don't think
he is going to rebase his branch now..
