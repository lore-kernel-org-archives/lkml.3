Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaEUIOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:14:05 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34468 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaEUIOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAOqmu80zZ3u+XUUaDedpNoziaSVZ_Qbc38yhy4aYVSF1riSfHQ@mail.gmail.com>
References: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
	<1400651502-23703-1-git-send-email-inderpal.s@samsung.com>
	<CAKohpo=UgVoBL2xNBwe_AoqtCOYj4Rcc=vHh2kb=64UHLjjiAw@mail.gmail.com>
	<CAOqmu80zZ3u+XUUaDedpNoziaSVZ_Qbc38yhy4aYVSF1riSfHQ@mail.gmail.com>
Date: Wed, 21 May 2014 13:43:59 +0530
Message-ID: <CAKohpokqGxEn4ogLDk69XrCdPEtAo9ywYTd1MS=12G-pY6GaVg@mail.gmail.com>
Subject: Re: [PATCH v2] PM / OPP: Implement opp_remove and free_opp_table functions
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Inderpal Singh <inderpal.s@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 May 2014 13:36, Inderpal Singh <inderpal.s@samsung.com> wrote:
> Its being used in opp_remove_and_free function to free dev_opp with kfree_rcu.

Wasn't aware of how kfree_rcu works :(
