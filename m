Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaBSUZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:25:07 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:47343 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaBSUZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:25:04 -0500
Message-ID: <53051308.5040202@elopez.com.ar>
Date: Wed, 19 Feb 2014 17:24:40 -0300
From: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140205183457.GW8533@titan.lakedaemon.net> <20140217141336.GA2765@localhost> <53021BD2.3090301@free-electrons.com> <20140217152147.GC2765@localhost> <53022AA9.8090606@free-electrons.com> <20140217154421.GD2765@localhost> <530231C5.8090905@free-electrons.com> <20140217181902.GG2765@localhost> <53032C14.9020502@free-electrons.com>
In-Reply-To: <53032C14.9020502@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

El 18/02/14 06:47, Gregory CLEMENT escribió:
(snip)
> (...) what would be an acceptable
> version would be the something like the patch attached. There will be still
> an issue if old dtb is used with recent kernel, but at least the user will
> be warned.

The patch you attached is similar in spirit to what I suggested, but 
with way more warnings sprinkled around. I don't really mind either way, 
and if you prefer big warnings so be it; it's your driver after all :-)

> This code only fix the Armada 370 case, a complete solution should modify
> the dtsi for Armada XP, Armada 375, Armada 38x, Kirkwood and Dove. It should
> also make the outputname mandatory for gate-clk for consistency.

Again, all of them are your calls. Fix the issue as you see fit; as long 
as it's a technically sound I'm ok with it. But please don't reinvent 
the wheel on framework code under a principle that has no proven reason 
to be to cover up for a buggy driver.

Cheers, and have a great Wednesday :)

Emilio

PS: I'd really appreciate it if you could keep me cc'ed on respins of 
patches I comment on in the future.
