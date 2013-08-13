Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab3HMBJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 21:09:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44278 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245Ab3HMBJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 21:09:31 -0400
Message-ID: <52098728.3020308@ti.com>
Date: Mon, 12 Aug 2013 20:08:56 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v3 08/12] dma: edma: Add one more required slot to MAX
 slots
References: <1375719297-12871-1-git-send-email-joelf@ti.com> <1375719297-12871-9-git-send-email-joelf@ti.com> <52087921.8040101@ti.com>
In-Reply-To: <52087921.8040101@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 12:56 AM, Sekhar Nori wrote:
> On Monday 05 August 2013 09:44 PM, Joel Fernandes wrote:
>> We'd now need a separate slot just for the channel and separate
>> ones for the 2 linked sets, so we make adjustments to allocate
>> an extra channel accordingly.
>>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
> 
> No need for a separate patch for this, just do this in the patch where
> you include the two linked sets.

Ok, I dropped this patch. Anyway, most of this patch has gone away now
because of other changes you suggested.

Thanks,

-Joel

