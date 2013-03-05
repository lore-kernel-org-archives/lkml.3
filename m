Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3CEWbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:31:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab3CEWbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:31:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] ARM: SPEAr13xx: Fix typo "ARCH_HAVE_CPUFREQ"
Date: Tue, 5 Mar 2013 22:31:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Paul Bolle <pebolle@tiscali.nl>, Shiraz Hashim <shiraz.hashim@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
References: <1362474819.16460.63.camel@x61.thuisdomein> <CAOh2x=m5r-yz993==vo-ezJttqN8XyXNqUsOYmv43EULOF_Pbw@mail.gmail.com>
In-Reply-To: <CAOh2x=m5r-yz993==vo-ezJttqN8XyXNqUsOYmv43EULOF_Pbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303052231.01143.arnd@arndb.de>
X-Provags-ID: V02:K0:hJEeP7B0wWW6c6KOERZdlBVRSSrbiz3AAMo4mB7Clwf
 TXJVHM0oX0t1hXXlwKKwNre19rq9T2VV/I9e4owrX8pGOaHmwX
 VhyLBjhvsq0p5LjMusKLCmhNttqA249HMiu/2g5LkhC6N+Pp7a
 cxKR3bn7I0dfmf+gIkVuvQhgS/zhh6cqZ4JBiTP9RW3AEu7Ema
 0mcFEc5zU8Goery1ZpkwyBgYd/ilzEAcf9pdAf6ejwMtjfZtBe
 9FAa8v2aZJ205S0RGBKIfKFrDV9tSTS4M/yJ6ODz3CWy7VEEFK
 erClG4pMlWNVfdWvwYfnZ8GvKI68zzacQV/ZIluEF1F8m+fLLO
 Va+4tVBhS0jWxGWTBwDI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 March 2013, Viresh Kumar wrote:
> On Tue, Mar 5, 2013 at 5:13 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > Do what commit f12a500e4adcc0961803e54b5ed1e74275d399f1
> > ("ARM: SPEAr13xx: Enable CONFIG_ARCH_HAS_CPUFREQ") wanted to do.
> >
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Ahh such stupid mistake.
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Applied in fixes branch, thanks!

	Arnd
