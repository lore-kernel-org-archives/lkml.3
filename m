Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab3CVLVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:21:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37964 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460Ab3CVLVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:21:01 -0400
Message-ID: <514C3E7C.3000705@ti.com>
Date: Fri, 22 Mar 2013 16:50:28 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>, <arnd@arndb.de>,
        <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>,
        <rob.herring@calxeda.com>, <linux-keystone@list.ti.com>,
        <viresh.linux@gmail.com>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 02/11] clk: davinci - add PSC clock driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-3-git-send-email-m-karicheri2@ti.com> <50950908.1060302@ti.com> <5097D6FC.7040202@ti.com> <20121110022254.18014.31873@nucleus> <50B4D6B1.3000903@ti.com> <20121127172900.21126.89528@nucleus> <50B6101C.30502@ti.com>
In-Reply-To: <50B6101C.30502@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On 11/28/2012 6:52 PM, Sekhar Nori wrote:
> On 11/27/2012 10:59 PM, Mike Turquette wrote:

>> Also have you looked into regmap?  Since you are defining your own clock
>> type that might be something nice for you.
> 
> No, haven't looked at regmap yet. Will look at that.

I could get to this only now. regmap needs a valid struct device. We
aren't modelling psc clocks as device so regmap cannot be used here.

Thanks,
Sekhar
