Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968Ab3DCGAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:00:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47637 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab3DCGAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:00:45 -0400
Message-ID: <515BC559.1070602@ti.com>
Date: Wed, 3 Apr 2013 11:29:53 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <akpm@linux-foundation.org>, <rob@landley.net>,
        <sylvester.nawrocki@gmail.com>, <swarren@wwwdotorg.org>,
        <cesarb@cesarb.net>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <mchehab@redhat.com>, <santosh.shilimkar@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/6] Generic PHY Framework
References: <1364449408-9510-1-git-send-email-kishon@ti.com> <20130328.143142.2080627792603647441.davem@davemloft.net>
In-Reply-To: <20130328.143142.2080627792603647441.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 29 March 2013 12:01 AM, David Miller wrote:
>
> You really need to CC: netdev@vger.kernel.org rather than me explicitly
> on this patch set.

I was CC'ing whatever get_maintainer shows. I'll make sure to CC 
netdev@vger.kernel.org though there's nothing related to network in this 
patch series (Maybe sometime in the future it'll be used).

Thanks
Kishon
