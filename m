Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967093AbaFTLUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:20:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55397 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966627AbaFTLUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:20:21 -0400
Message-ID: <53A418EF.5050005@ti.com>
Date: Fri, 20 Jun 2014 16:50:15 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>, Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <rnayak@ti.com>, <nm@ti.com>, <kishon@ti.com>,
        <george.cherian@ti.com>, <balbi@ti.com>, <balajitk@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: DRA7: hwmod: Add OCP2SCP3 module
References: <1403093816-10960-1-git-send-email-rogerq@ti.com> <1403093816-10960-2-git-send-email-rogerq@ti.com> <alpine.DEB.2.02.1406190546520.13869@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1406190546520.13869@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 June 2014 11:18 AM, Paul Walmsley wrote:
> On Wed, 18 Jun 2014, Roger Quadros wrote:
> 
>> This module is needed for the SATA and PCIe PHYs.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> Tested-by: Roger Quadros <rogerq@ti.com>
> 
> Is this one a fix?  It looks to me like a new IP block addition.

This is not a regression fix, but this is the only thing preventing
users from using SATA on DRA7x - the DT fragments are already there.

Since its still early -rc cycle, I am hoping enabling support for new
devices can still go in.

Thanks,
Sekhar
