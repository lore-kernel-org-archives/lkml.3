Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaLRCLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:11:17 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33555 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaLRCLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:11:15 -0500
MIME-Version: 1.0
In-Reply-To: <20141217234713.GT5310@linux.vnet.ibm.com>
References: <1418771379-24369-1-git-send-email-dtor@chromium.org>
	<1418771379-24369-4-git-send-email-dtor@chromium.org>
	<CAKohpok0UieH=Pi4nU2tKqV1_LH+3uzMDr0B8wsN61g1BnG4pg@mail.gmail.com>
	<20141217234713.GT5310@linux.vnet.ibm.com>
Date: Thu, 18 Dec 2014 07:41:14 +0530
Message-ID: <CAKohpo=ocsVseYj0Ee5rYqMgTDnd9jkvzCFJmaTUFrbiLH1_vw@mail.gmail.com>
Subject: Re: [PATCH 3/4] PM / OPP: take RCU lock in dev_pm_opp_get_opp_count
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dmitry Torokhov <dtor@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 December 2014 at 05:17, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Yep, they can be nested.  Both rcu_read_lock() and rcu_read_unlock()
> are quite fast, as are their friends, so there is almost no performance
> penalty from nesting.  So the decision normally turns on maintainability
> and style.

Thanks again for your kind advice :)
