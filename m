Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab3FMIkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:40:22 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43248 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab3FMIkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAFgnuDdSKDS_P2qRvCZmQzhxketojm0tQb6COuk2gnuQfs-Ztw@mail.gmail.com>
References: <1371028189-15758-1-git-send-email-chenxg@marvell.com>
	<CAKohponeWuaXPah4s9GjO-fLwQNuyKidUFosN1iE+e7bngDPdQ@mail.gmail.com>
	<CAFgnuDeeU5qALyqN4Akpi5SoHRXPWaq_PLYSSmjxkq9V5N=qag@mail.gmail.com>
	<CAKohpom0-Z+s4G+OOhVZJn=HK7NVKHCXS-_0FJd07K+L5DwgHA@mail.gmail.com>
	<CAFgnuDdSKDS_P2qRvCZmQzhxketojm0tQb6COuk2gnuQfs-Ztw@mail.gmail.com>
Date: Thu, 13 Jun 2013 14:10:17 +0530
Message-ID: <CAKohpomkKsF=-jwGw0nroi9fPAT_MWGUNnrzVobAnvn_iHAwWw@mail.gmail.com>
Subject: Re: [PATCH v4] cpufreq: fix governor start/stop race condition
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg.marvell@gmail.com>
Cc: Xiaoguang Chen <chenxg@marvell.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 June 2013 12:49, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:

> So you add the return value checking, I was about to do it in another patch :)

What? I couldn't related that statement to my code.

> this patch is simpler than my previous patch,  it is ok for me.
> Do I need to submit it again or it can be merged?

Yeah.. Send this patch as another version so that Rafael can easily pick it
up.
