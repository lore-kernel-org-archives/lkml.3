Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935976Ab3DHMtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:49:19 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:46181 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935075Ab3DHMtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:49:16 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.123.88]
In-Reply-To: <1365384999.31128.6.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <1365384999.31128.6.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 8 Apr 2013 15:48:52 +0300
Message-ID: <CAK=WgbZUrVCeFhXjBGirJmYehy2MDnWYF8OVjyMTgfx5sK5_zQ@mail.gmail.com>
Subject: Re: [PATCH 2/5 V2] mmc: core: call pm_runtime_put_noidle in
 pm_runtime_get_sync failed case
To: Li Fei <fei.li@intel.com>
Cc: Chris Ball <cjb@laptop.org>, "ulf.hansson" <ulf.hansson@linaro.org>,
        "johan.rudholm" <johan.rudholm@stericsson.com>,
        subhashj <subhashj@codeaurora.org>,
        "rafael.j.wysocki" <rafael.j.wysocki@intel.com>,
        "thierry.reding" <thierry.reding@avionic-design.de>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        "Coelho, Luciano" <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 4:36 AM, Li Fei <fei.li@intel.com> wrote:
> Even in failed case of pm_runtime_get_sync, the usage_count
> is incremented. In order to keep the usage_count with correct
> value and runtime power management to behave correctly, call
> pm_runtime_put_noidle in such case.
>
> Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>

Acked-by: Ohad Ben-Cohen <ohad@wizery.com>

BTW, Li, could you please move to _noidle in those other places where
your previous patch was already applied? I think we have at least the
12xx driver (cc'ing Luca).

Thanks!
Ohad.
