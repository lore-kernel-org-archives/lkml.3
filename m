Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaLSRgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:36:16 -0500
Received: from exprod5og125.obsmtp.com ([64.18.0.245]:46842 "HELO
	exprod5og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751414AbaLSRgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:36:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141219.123107.1080751255468272638.davem@davemloft.net>
References: <1418945991-31494-1-git-send-email-fkan@apm.com>
	<20141219.123107.1080751255468272638.davem@davemloft.net>
Date: Fri, 19 Dec 2014 09:36:13 -0800
Message-ID: <CAL85gmCOLrcTijpEhXx1x5UjHu0sgS5DdGYJxY4mwPFKCHpU-g@mail.gmail.com>
Subject: Re: [PATCH] net: eth: xgene: change APM X-Gene SoC platform ethernet
 to support ACPI
From: Feng Kan <fkan@apm.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 9:31 AM, David Miller <davem@davemloft.net> wrote:
> From: Feng Kan <fkan@apm.com>
> Date: Thu, 18 Dec 2014 15:39:51 -0800
>
>> +#define NO_MAC_FOUND 0
>> +#define RES_ENET_CSR 0
>> +#define RES_RING_CSR 1
>> +#define RES_RING_CMD 2
Is there a issue with the RES defines, do you prefer enum types?

>
> Don't define your own magic set of error return semantics.
>
> For example, in the MAC address acquisition case, just verify that
> you get an ETH_ALEN length value from the fetch routines and return
> -ENODEV or similar if you do not.
Thanks, well change.
