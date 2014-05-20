Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaETOtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:49:32 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54970 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaETOta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:49:30 -0400
MIME-Version: 1.0
In-Reply-To: <537B6663.30005@ti.com>
References: <d0200ee9e30de19f69ca1b7e53a8cd7a047fa436.1400595283.git.viresh.kumar@linaro.org>
	<537B6663.30005@ti.com>
Date: Tue, 20 May 2014 20:19:29 +0530
Message-ID: <CAKohpok5QZvQzSkDxeLTnRK9F0Zf0kr2PD+gbP+FqmhL_dYLCQ@mail.gmail.com>
Subject: Re: [PATCH V4] PM/OPP: discard duplicate OPPs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
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

On 20 May 2014 19:57, Nishanth Menon <nm@ti.com> wrote:
>> +             pr_warn("%s: duplicate OPPs detected. Existing: freq: %lu, volt: %lu, enabled: %d. New: freq: %lu, volt: %lu, enabled: %d\n",
> dev_warn please? we already know the dev pointer. Also can we reduce
> this down to 80 character limit if possible?

breaking printk string into multiple line isn't suggested as it affects
readability and so I kept it this way. Another was was to break printk
itself intro two-three printk lines, but that would have looked bad
on console.

So, will retain it :(
