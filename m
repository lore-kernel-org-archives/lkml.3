Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaETN3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:29:48 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:46508 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaETN3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:29:46 -0400
MIME-Version: 1.0
In-Reply-To: <2638341.ymNLNAMmAG@vostro.rjw.lan>
References: <1400230809-11401-1-git-send-email-chander.kashyap@linaro.org>
	<CAKohponAx=Hi_Ywgg4hXxrpmmaqy5=pYnb3nSBNUP3KtADTEeA@mail.gmail.com>
	<CAKohpomKvPcioNmfzvx7vqJHqs_TrhnHH6yYb5w_0f+YvA5hvA@mail.gmail.com>
	<2638341.ymNLNAMmAG@vostro.rjw.lan>
Date: Tue, 20 May 2014 18:59:45 +0530
Message-ID: <CAKohpokkPjgruJGam3p0vc9xHThpDiTMRoiEG5y5PB_RDZSHLQ@mail.gmail.com>
Subject: Re: [PATCH v3] PM / OPP: discard duplicate OPPs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Nishanth Menon <nm@ti.com>, Chander Kashyap <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2014 18:15, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>                 int ret = new_opp->u_volt == opp->u_volt ? -EEXIST : 0;
>
> would be slightly simpler IMO.

Much better :)
