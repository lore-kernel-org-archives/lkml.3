Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab3HNQoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:44:00 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:53428 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab3HNQn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:43:58 -0400
MIME-Version: 1.0
In-Reply-To: <538b0cb147d3bd4a5e21b49c507f725f7fb7feb9.1375279948.git.viresh.kumar@linaro.org>
References: <cover.1375279948.git.viresh.kumar@linaro.org>
	<538b0cb147d3bd4a5e21b49c507f725f7fb7feb9.1375279948.git.viresh.kumar@linaro.org>
Date: Wed, 14 Aug 2013 18:43:57 +0200
Message-ID: <CACRpkdZ47M3VHFgWwHeDF-SptCMdvjFotFtV65VrGNewFCbNhw@mail.gmail.com>
Subject: Re: [PATCH 04/15] cpufreq: dbx500: initialize .owner field with THIS_MODULE
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>, cpufreq@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 4:19 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> CPUFreq core does following at multiple places:
> module_{get|put}(cpufreq_driver->owner)).
>
> This is done to make sure module doesn't get unloaded if it is currently in use.
> This will work only if the .owner field of cpufreq driver is initialized with a
> valid pointer.
>
> This field wasn't initialized for this driver, lets initialize it with
> THIS_MODULE.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
