Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3F0PZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:25:10 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52139 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3F0PZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130627152143.GA5324@jshin-Toonie>
References: <51C87ADC.4070409@canonical.com>
	<CAKohponCrC93D88Fgg_3LKsLG0KMeCVKsTEoy-N3jsdUQdgWvA@mail.gmail.com>
	<20130625161935.GA10208@jshin-Toonie>
	<CAKohpomSa0FRviZHkkJOeUUxubbzueVb3yyP5G8ASwpRB6wANQ@mail.gmail.com>
	<20130626142852.GA2326@jshin-Toonie>
	<CAKohpom_jHQeR2FKFS3-RkxpPrJvekw8pDb-qnApnzu-VqreBQ@mail.gmail.com>
	<20130626175722.GA20226@jshin-Toonie>
	<CAKohpo=UTmpLmyQs5+xLNnCLMCeZHNQT3USjmK1NTaFJLNQg-Q@mail.gmail.com>
	<20130627145505.GA3076@jshin-Toonie>
	<CAKohpomSNGn1wTzbCxpHN5fu2L6mJ1fnhvt2uLBWLgQE8fS6Rg@mail.gmail.com>
	<20130627152143.GA5324@jshin-Toonie>
Date: Thu, 27 Jun 2013 20:55:07 +0530
Message-ID: <CAKohpomJRhbgHx08ifgychMTOsk=WqtvAKAOSrbu_iE8w8b2bQ@mail.gmail.com>
Subject: Re: od_set_powersave_bias: NULL pointer dereference
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 June 2013 20:51, Jacob Shin <jacob.shin@amd.com> wrote:
> Sorry I totally missed it,
>
> I was trying to account for the case when od_set_powersave_bias() is
> called while ondemand is not the current governor. And then later
> becomes the current governor. So when od_init() is called it will take
> the expected default, rather than 0.

Ok. leave it as is.
