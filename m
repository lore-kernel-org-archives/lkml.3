Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaEWPOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:14:15 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:48079 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaEWPOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <1400857500.31526.52.camel@x220>
References: <1400702036.30334.6.camel@x220>
	<CAK9yfHz2kdfkf+o7fKMRu=nMXxbcHJ227bjpvA=WXt6ptH3QRA@mail.gmail.com>
	<1400740894.21254.8.camel@x220>
	<CAK9yfHzf-Z3AQ4+-sF7xqqUw4dN8aULkCNvLQnmusp_ZiOg+Rw@mail.gmail.com>
	<1400857500.31526.52.camel@x220>
Date: Fri, 23 May 2014 20:44:12 +0530
Message-ID: <CAK9yfHxXBpHnAWz3m2HujAoa4DGD=qUqKX=ZVD4UG-iowvcc=g@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: s5pv210: drop check for CONFIG_PM_VERBOSE
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 23 May 2014 20:35, Paul Bolle <pebolle@tiscali.nl> wrote:
> A pr_err() was added in v3.1. It was guarded by a check for
> CONFIG_PM_VERBOSE. The Kconfig symbol PM_VERBOSE was removed in v3.0. So
> this pr_err() has never been used. Drop that check and clean up the
> message a bit.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Reviewed-by: Sachin Kamat <sachin.kamat@linaro.org>
