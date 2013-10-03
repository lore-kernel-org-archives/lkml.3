Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3JCSRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:17:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33752 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3JCSRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:17:33 -0400
Message-ID: <524DB48B.7020906@ti.com>
Date: Thu, 3 Oct 2013 13:16:43 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] hwspinlock/omap: add support for dt nodes
References: <1378230767-54931-1-git-send-email-s-anna@ti.com> <20131003180546.GP8949@atomide.com>
In-Reply-To: <20131003180546.GP8949@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,

On 10/03/2013 01:05 PM, Tony Lindgren wrote:
> * Suman Anna <s-anna@ti.com> [130903 11:00]:
>> HwSpinlock IP is present only on OMAP4 and other newer SoCs,
>> which are all device-tree boot only. This patch adds the
>> base support for parsing the DT nodes, and removes the code
>> dealing with the traditional platform device instantiation.
> 
> Great, this should be safe for Ohad to queue:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>
> 

There is a v2 of this series [1] that adds additional SoC support as
well. It currently has some comments [2] & [3] from Mark Rutland on the
DT bindings. I am looking into that at the moment and it may change this
patch as well (the DT parse portion of it in
drivers/hwspinlock/omap_hwspinlock).

regards
Suman

[1] http://marc.info/?l=linux-omap&m=137944644112727&w=2
[2] http://marc.info/?t=137944636400005&r=1&w=2
[3] http://marc.info/?t=137944636400004&r=1&w=2


