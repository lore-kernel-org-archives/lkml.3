Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3HUXBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:01:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35363 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3HUXBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:01:00 -0400
MIME-Version: 1.0
In-Reply-To: <580c144ac4a85899ddc3d6350e50761c9d69b1fe.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
	<580c144ac4a85899ddc3d6350e50761c9d69b1fe.1377093938.git.viresh.kumar@linaro.org>
Date: Thu, 22 Aug 2013 01:00:59 +0200
Message-ID: <CACRpkdY33h7GC1Q2hQZzBYJiQM9qvSGYBFabaaMJg8wBZG1=TQ@mail.gmail.com>
Subject: Re: [PATCH 03/14] cpufreq: dbx500: use cpufreq_generic_init() routine
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>, cpufreq@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 4:42 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Use generic cpufreq_generic_init() routine instead of replicating the same code
> here.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
