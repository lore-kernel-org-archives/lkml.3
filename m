Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab3CEJZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:25:17 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35080 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab3CEJZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:25:09 -0500
MIME-Version: 1.0
In-Reply-To: <1362474819.16460.63.camel@x61.thuisdomein>
References: <1362474819.16460.63.camel@x61.thuisdomein>
Date: Tue, 5 Mar 2013 17:19:03 +0800
X-Google-Sender-Auth: 5ZnYLA6zuN1lYS4IsRifeYvvc8M
Message-ID: <CAOh2x=m5r-yz993==vo-ezJttqN8XyXNqUsOYmv43EULOF_Pbw@mail.gmail.com>
Subject: Re: [PATCH] ARM: SPEAr13xx: Fix typo "ARCH_HAVE_CPUFREQ"
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Shiraz Hashim <shiraz.hashim@st.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 5:13 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Do what commit f12a500e4adcc0961803e54b5ed1e74275d399f1
> ("ARM: SPEAr13xx: Enable CONFIG_ARCH_HAS_CPUFREQ") wanted to do.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Ahh such stupid mistake.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
