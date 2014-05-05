Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956AbaEEOXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:23:39 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60518 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636AbaEEOXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpon-KZpSJK7PxpLjZS7sVPcYraDxb4oJHN6dxSagD+F--Q@mail.gmail.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
	<CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
	<003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
	<CAKohpon7W726Hxj5OJ6SnmPz3gYhAeBRr1wS3SCa3F2hSLriLQ@mail.gmail.com>
	<5367946F.1030407@ti.com>
	<CAKohpon-KZpSJK7PxpLjZS7sVPcYraDxb4oJHN6dxSagD+F--Q@mail.gmail.com>
Date: Mon, 5 May 2014 09:23:36 -0500
X-Google-Sender-Auth: nujfjDj_6fDV-aEDWK7Gxfk3TgI
Message-ID: <CAGo_u6pUVeMM9mqe5htvM1X_4pkRGEUVOA2ty4ZPfUyLcLZkrw@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
 cpufreq table
From: Nishanth Menon <nm@ti.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 9:14 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> To be precise, for exynos they need the position of a frequency when
> it is arranged in descending order. And they will simply write this position
> in their clock controller later. For example, if frequencies are:
> 100 MHz, 200, 300, 400, 500, 600
>
> Then they need to write 1 for 600, 2 for 500, 3 for 400, and so on..
> I am not able to imaging how ceil/floor would help here.

ceil and floor allows us to walk down the opp entries the direction we
want it to.
one can convert that data any way one wants it - especially when custom
mapping such as this is desired.

Regards,
Nishanth Menon
