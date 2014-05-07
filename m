Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaEGUbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:31:36 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:35171 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaEGUbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:31:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140507202841.GH28159@titan.lakedaemon.net>
References: <5369063f.4291420a.03aa.495e@mx.google.com>
	<20140507142056.GD28159@titan.lakedaemon.net>
	<10890279.Lp5U737Dmi@wuerfel>
	<20140507145656.GE28159@titan.lakedaemon.net>
	<7hioph2xfv.fsf@paris.lan>
	<20140507202841.GH28159@titan.lakedaemon.net>
Date: Wed, 7 May 2014 13:31:33 -0700
Message-ID: <CAGa+x86kQT9B+tUHPEmWX2_r3bxbdRWghJ39AFGQ5r1roR+Lqw@mail.gmail.com>
Subject: Re: IPMI misbehaving on ARM defconfigs, was [Re: stable boot: 18
 pass, 4 fail (v3.10.39)]
From: Kevin Hilman <khilman@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Corey Minyard <minyard@acm.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel-build-reports@lists.linaro.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        openipmi-developer@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 1:28 PM, Jason Cooper <jason@lakedaemon.net> wrote:
[...]

> On a broader topic, if we have users in the field running v3.10.y on ARM
> systems, then I think it's worth backporting the defconfig changes to
> boot-test those systems.

Yeah, especially since v3.10 is LTS, it's probably worth doing, though
not sure if anyone using LTS cares about multi_v7_defconfig.

> I'll see if I can generate a list of patches.

Thanks.

Kevin
