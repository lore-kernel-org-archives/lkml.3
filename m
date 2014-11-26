Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaKZQcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:32:15 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59825 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbaKZQcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:32:13 -0500
Message-ID: <5476005A.6090207@ti.com>
Date: Wed, 26 Nov 2014 18:31:22 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Sekhar Nori <nsekhar@ti.com>,
        <linux-i2c@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Mike Looijmans <milo-software@users.sourceforge.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH v2 2/5] i2c: davinci: query STP always when NACK is received
References: <1417010393-30598-1-git-send-email-grygorii.strashko@ti.com> <1417010393-30598-3-git-send-email-grygorii.strashko@ti.com> <20141126155711.GL4431@pengutronix.de>
In-Reply-To: <20141126155711.GL4431@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 05:57 PM, Uwe Kleine-König wrote:
> Hello,
>
> I don't understand your use of "query" in the subject and later in the
> commit log. Do you mean "send"?

will change to "generate". Ok?

>
> On Wed, Nov 26, 2014 at 03:59:50PM +0200, Grygorii Strashko wrote:
>> According to I2C specification the NACK should be handled as folows:
> s/folows/follows/
ok.

Can I assume that you are ok with this patch in general?

regards,
-grygorii


