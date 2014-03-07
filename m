Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbaCGQq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:46:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37949 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbaCGQq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:46:27 -0500
Message-ID: <5319F7D2.8040801@ti.com>
Date: Fri, 7 Mar 2014 22:16:10 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Chris Ball <chris@printf.net>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>, Stefan Roese <sr@denx.de>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 2/3] regulator: pbias: Convert to use regmap helper functions
References: <1394206897.17867.1.camel@phoenix> <1394206993.17867.3.camel@phoenix>
In-Reply-To: <1394206993.17867.3.camel@phoenix>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 March 2014 09:13 PM, Axel Lin wrote:
> This patch converts this driver to use the regmap helper functions provided by
> regulator core.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Balaji T K <balajitk@ti.com>

> ---
>   drivers/regulator/pbias-regulator.c | 74 ++++++++++---------------------------
>   1 file changed, 19 insertions(+), 55 deletions(-)
>
