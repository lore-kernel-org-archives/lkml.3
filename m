Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaETOyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:54:20 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:39975 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaETOyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:54:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpok5QZvQzSkDxeLTnRK9F0Zf0kr2PD+gbP+FqmhL_dYLCQ@mail.gmail.com>
References: <d0200ee9e30de19f69ca1b7e53a8cd7a047fa436.1400595283.git.viresh.kumar@linaro.org>
	<537B6663.30005@ti.com>
	<CAKohpok5QZvQzSkDxeLTnRK9F0Zf0kr2PD+gbP+FqmhL_dYLCQ@mail.gmail.com>
Date: Tue, 20 May 2014 09:54:14 -0500
X-Google-Sender-Auth: Hvp2C49_JlJlyWR_OtpUGK_uJHE
Message-ID: <CAGo_u6p0VMEOxcvQMzyCjTN2MQqgdPCsuYvJdKRmdoqDs0qKLw@mail.gmail.com>
Subject: Re: [PATCH V4] PM/OPP: discard duplicate OPPs
From: Nishanth Menon <nm@ti.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Chander Kashyap <k.chander@samsung.com>,
        Viresh Kumar <viresh.kumar@linrao.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 9:49 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> breaking printk string into multiple line isn't suggested as it affects
> readability and so I kept it this way. Another was was to break printk
> itself intro two-three printk lines, but that would have looked bad
> on console.
>
> So, will retain it :(
OK, dev_warn at least should be done.. we use dev_warn everywhere else.

Regards,
Nishanth Menon
