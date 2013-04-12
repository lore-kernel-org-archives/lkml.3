Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab3DLSPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:15:46 -0400
Received: from void.printf.net ([89.145.121.20]:35751 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab3DLSPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:15:44 -0400
From: Chris Ball <cjb@laptop.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Li Fei <fei.li@intel.com>, "ulf.hansson" <ulf.hansson@linaro.org>,
        "johan.rudholm" <johan.rudholm@stericsson.com>,
        subhashj <subhashj@codeaurora.org>,
        "rafael.j.wysocki" <rafael.j.wysocki@intel.com>,
        "thierry.reding" <thierry.reding@avionic-design.de>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        "Coelho\, Luciano" <coelho@ti.com>
Subject: Re: [PATCH 2/5 V2] mmc: core: call pm_runtime_put_noidle in pm_runtime_get_sync failed case
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	<1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	<1365384999.31128.6.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	<CAK=WgbZUrVCeFhXjBGirJmYehy2MDnWYF8OVjyMTgfx5sK5_zQ@mail.gmail.com>
Date: Fri, 12 Apr 2013 14:15:35 -0400
In-Reply-To: <CAK=WgbZUrVCeFhXjBGirJmYehy2MDnWYF8OVjyMTgfx5sK5_zQ@mail.gmail.com>
	(Ohad Ben-Cohen's message of "Mon, 8 Apr 2013 15:48:52 +0300")
Message-ID: <877gk7fwe0.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 08 2013, Ohad Ben-Cohen wrote:
> On Mon, Apr 8, 2013 at 4:36 AM, Li Fei <fei.li@intel.com> wrote:
>> Even in failed case of pm_runtime_get_sync, the usage_count
>> is incremented. In order to keep the usage_count with correct
>> value and runtime power management to behave correctly, call
>> pm_runtime_put_noidle in such case.
>>
>> Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
>> Signed-off-by: Li Fei <fei.li@intel.com>
>
> Acked-by: Ohad Ben-Cohen <ohad@wizery.com>

Thanks, pushed this patch to mmc-next for 3.10.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
