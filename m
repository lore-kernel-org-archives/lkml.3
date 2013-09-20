Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3ITRB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:01:29 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:63212 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3ITRB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:01:28 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbEdR6g7cGouSxVoCp7jFRUSmP9yKcu5+afEMqUR45Kfg@mail.gmail.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com>
	<CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com>
	<CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com>
	<CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com>
	<CACRpkdZDqoqrEPfdra+iVS-hopLpJbPmWh=r8UkYRFUMg17jpw@mail.gmail.com>
	<523C6A88.30800@linux.vnet.ibm.com>
	<CACRpkdasfW9OzZHPgfksjkHgw+Z-n7Tc_d2yXYy+BjShUhAYFg@mail.gmail.com>
	<CACRpkdbEdR6g7cGouSxVoCp7jFRUSmP9yKcu5+afEMqUR45Kfg@mail.gmail.com>
Date: Fri, 20 Sep 2013 22:31:27 +0530
Message-ID: <CAKohpokFzxaDt+oYY2tZXs3EBCRcByuv1buQECpdSzjN4e6x9g@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 September 2013 22:04, Linus Walleij <linus.walleij@linaro.org> wrote:
> In this case we have neither. So the cpufreq driver fails to
> register. But the kernel used to survive in any case, as you
> could call cpufreq_get() without a cpufreq driver registered.

Aha, so exactly what I suspected in my first mail..
