Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbaLKKhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:37:47 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33799 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaLKKhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:37:45 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-16-548973cbea33
Message-id: <548973B7.3050107@samsung.com>
Date: Thu, 11 Dec 2014 11:36:39 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Tomasz Figa <tfiga@chromium.org>
Cc: linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Heiko Stuebner <heiko@sntech.de>, Joerg Roedel <joro@8bytes.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: Re: [RFC PATCH 1/2] pm: Add PM domain notifications
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org>
 <1418286387-9663-2-git-send-email-tfiga@chromium.org>
In-reply-to: <1418286387-9663-2-git-send-email-tfiga@chromium.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xK7qniztDDL6f1rBonDGf1WLu7EmM
	Fv8fvWa1WLDf2qJz9gZ2i6+HVzBazJqyl8li0+NrrBaXd81hs/jce4TR4tOD/8wWd08dZbM4
	c/oSq8Xn1n9sFsfXhjvwezw5OI/JY3bDRRaPiWd1PRbvecnkcefaHjaPzUvqPSbfWM7oseVq
	O4vH9mvzmD1WrP7O7vF5k1wAdxSXTUpqTmZZapG+XQJXRs/WhYwFR9gqGvYuYWlg3MLaxcjJ
	ISFgIrHv6TUoW0ziwr31bCC2kMBSRokHa/i6GLmA7E+MEo2TNjKDJHgFtCRufu1lAbFZBFQl
	vt66BWazCRhK9B7tYwSxRQUiJE7e3cMOUS8o8WPyPbAaEQEVid8nZ7CBDGUW+MkscfDgbbAi
	YQEbiZ4vPSwQmyslOs9NB7M5BZwkDhz8DnQdB1CDnsT9i1ogYWYBeYnNa94yT2AUmIVkxSyE
	qllIqhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImzLzsYFx+zOsQowMGoxMMrENsZ
	IsSaWFZcmXuIUYKDWUmE1yoCKMSbklhZlVqUH19UmpNafIiRiYNTqoHRYMHVz0ldh9acl5nv
	ymZWZhi/RuACX3qqk84z7dZUw/xdK7niTJVeuRzyXury/v28epGlTzb0a7J6pr/fHOPAKC0Y
	sDrhh/1L1faLEw7aZ3+7Ee27b983ju1szmpNntJf3xlzW39wE5UP3J3jXPnTv/ZS9Q/763uj
	1c6J283vaQy98EVp0kwlluKMREMt5qLiRABdf5JOkQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 11/12/14 09:26, Tomasz Figa wrote:
> From: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> This patch adds notifiers to the runtime PM/genpd subsystem. It is now
> possible to register a notifier, which will be called before and after
> the generic power domain subsystem calls the power domain's power_on
> and power_off callbacks.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> [tfiga@chromium.org: rebased]
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>

Not sure if you've noticed it, I posted an updated version of this patch
recently [1]. The notifiers list is moved to struct generic_pm_domain
there and it also allows to register a notifier for selected power domain
by name.

-- 
Regards,
Sylwester

[1] http://www.spinics.net/lists/linux-samsung-soc/msg38549.html
