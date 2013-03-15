Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3COKhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:37:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43314 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab3COKhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:37:03 -0400
Message-ID: <5142F9B3.3050800@ti.com>
Date: Fri, 15 Mar 2013 16:06:35 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        <broonie@opensource.wolfsonmicro.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux@arm.linux.org.uk>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>
Subject: Re: [RESEND 0/2] davinci: Add device tree data for tps6507x.
References: <1362637581-12673-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1362637581-12673-1-git-send-email-manishv.b@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 3/7/2013 11:56 AM, Vishwanathrao Badarkhe, Manish wrote:
> Add device tree data for regulator via tps6507x mfd device 
> in da850-evm.
> Applies on top of v3.9-rc1 of linus tree.

I would like to take this series via the davinci tree to manage
dependencies with rest of the DT patches. Any comments/objections on
this series? It will be nice to get your Acked-by/Reviewed-by.

Thanks,
Sekhar
