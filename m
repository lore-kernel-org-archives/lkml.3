Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaIJXpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:45:16 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55552 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751457AbaIJXpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:45:14 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Anup Chenthamarakshan <anupc@chromium.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Sameer Nanda <snanda@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_pstate: track and export frequency residency stats via sysfs.
Date: Thu, 11 Sep 2014 02:04:44 +0200
Message-ID: <7546673.Ir6ttItgPU@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140910233905.GA2439@google.com>
References: <1410221424-20590-1-git-send-email-anupc@chromium.org> <1610826.tK4V65ABJD@vostro.rjw.lan> <20140910233905.GA2439@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 10, 2014 04:39:05 PM Anup Chenthamarakshan wrote:
> On Thu, Sep 11, 2014 at 12:49:48AM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, September 10, 2014 03:15:08 PM Anup Chenthamarakshan wrote:
> > > 
> > > Tools like powertop and turbostat are not present by default on all systems,
> > > so it is not always possible to use them :(
> > 
> > Which systems are you referring to in particular?
> 
> We're testing on Chrome OS devices (Chromebooks).

How big of a deal is it to install the tools mentioned above on such a system?

At least turbostat is shipped with the kernel source.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
