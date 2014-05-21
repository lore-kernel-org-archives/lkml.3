Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbaEUEDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:03:44 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35085 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaEUEDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <1555967.8fxByr2j83@vostro.rjw.lan>
References: <7cb6e0e039e0935e37c81d0f23d26b0b81ad8cda.1400597170.git.viresh.kumar@linaro.org>
	<1555967.8fxByr2j83@vostro.rjw.lan>
Date: Wed, 21 May 2014 09:33:42 +0530
Message-ID: <CAKohponU2feK9+9sUn4tu0t4fhwSy6PZuaAO3zkF7qRejCwM1Q@mail.gmail.com>
Subject: Re: [PATCH V5] PM/OPP: discard duplicate OPPs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>, Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Chander Kashyap <k.chander@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 May 2014 02:39, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> +     /* Duplicate OPPs ? */
>> +     if (new_opp->rate == opp->rate) {
>> +             int ret = (new_opp->u_volt == opp->u_volt) && opp->available ?
>> +                     0 : -EEXIST;
>
> The parens are not necessary.  And is the direction correct?

What do you mean by direction here ?
