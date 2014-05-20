Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaETCic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:38:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60631 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaETCia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:38:30 -0400
MIME-Version: 1.0
In-Reply-To: <1458497.gJ29RmexAd@vostro.rjw.lan>
References: <60d825e8bfe01f8a5ff98fffaf51ffbf04c7d175.1400480033.git.viresh.kumar@linaro.org>
	<ca7cc76c49806ce1ac8f9617fa4266cfc29d1ea1.1400480592.git.viresh.kumar@linaro.org>
	<4765191.0FhyvSGyvF@vostro.rjw.lan>
	<1458497.gJ29RmexAd@vostro.rjw.lan>
Date: Tue, 20 May 2014 08:08:29 +0530
Message-ID: <CAKohponzi0qcA6Zs8u=fPFpYXc4rC_ybV3EKu212mDXYekNKug@mail.gmail.com>
Subject: Re: [PATCH Resend] driver/core: cpu: initialize opp table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2014 02:46, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> Do patches [2-5/5] depend on this one BTW?

Yes.
