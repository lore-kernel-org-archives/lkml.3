Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaDNOVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:21:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23108 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaDNOVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:21:37 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-0a-534beeef94b7
Message-id: <534BEEED.1060309@samsung.com>
Date: Mon, 14 Apr 2014 16:21:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
 <1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
 <534529B2.2020107@samsung.com> <534BCC91.8090108@ti.com>
 <CAFp+6iGxhfgZRPysMuj5nALEQBbFXnAXhtDPpbf3P42LDHqFxg@mail.gmail.com>
 <534BDD17.60003@ti.com> <534BE658.8050606@gmail.com>
 <CAFp+6iHhUvLhAKGPARS8RUfmO8RGcTrumvYb7QjJXbFD1nUuig@mail.gmail.com>
In-reply-to: <CAFp+6iHhUvLhAKGPARS8RUfmO8RGcTrumvYb7QjJXbFD1nUuig@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t/xy7rv33kHG+zdxW5x8H69xfwj51gt
	3n7fwm7RvHg9m8XlhZdYLX68vsBm0bvgKpvFhac9bBabHl9jtVjYtoTF4vKuOWwWM87vY7JY
	tKyV2WLe551MFutnvGaxWLXrD6ODgMfOWXfZPfbPXcPusXlJvUffllWMHsdvbGfy+LxJLoAt
	issmJTUnsyy1SN8ugSvj4vKHLAUTmCtmnXjE1MC4kamLkZNDQsBEYvmFE8wQtpjEhXvr2boY
	uTiEBJYySrxc84odJCEk8IlR4uJkfxCbV0BL4vr53SwgNouAqsSujjNsIDabgKFE79E+RhBb
	VCBC4l7jYVaIekGJH5PvgdWLCOhIHGrtZwFZwCxwnFXi5s5dYJuFBZwlLs9YArWsnVni5gJX
	EJtTIFji+5LHYJcyC6hLTJq3iBnClpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKppckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGCFx9HUH49JjVocYBTgYlXh4O+Z4BwuxJpYVV+YeYpTgYFYS4XXd
	ChTiTUmsrEotyo8vKs1JLT7EyMTBKdXAaFmy8sf+BTo13DpLiw+VpqzverZHp3LVx94P95ab
	BByY4zvjZ4rV31NOlwR/Fn2Y3ODJoNjlN3+f3YaOxSu3cWjf3ivt9nunqfT+0C3nj++scpTv
	YkqcX+Ch8erJ4d+GrzbbhFRxswc4JN4/YSoy+cpfjrT3225tCZ6yr2XL0a87e6bprf68fZES
	S3FGoqEWc1FxIgBKXvpigQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/14 15:49, Vivek Gautam wrote:
> True, we don't have a scope of instantiating this driver using old
> platform device and
> old legacy board files.
> So we don't need this check then, right ?

I think it can be dropped.
At least IMHO there is no point to increase size of the module with
an error log that has no chance to be ever called in practice.

--
Thanks,
Sylwester



