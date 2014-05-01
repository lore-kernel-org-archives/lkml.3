Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaEAE7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 00:59:34 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:58429 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaEAE7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 00:59:32 -0400
Message-ID: <5361D479.5010709@synopsys.com>
Date: Thu, 1 May 2014 10:28:33 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.network
To: Max Schwarz <max.schwarz@online.de>,
        "David S. Miller" <davem@davemloft.net>
CC: Alexey Brodkin <Alexey.Brodkin@synopsys.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH] arc_emac: write initial MAC address from devicetree to
 hw
References: <1664530.jeK9vBIgft@typ>
In-Reply-To: <1664530.jeK9vBIgft@typ>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 April 2014 05:47 AM, Max Schwarz wrote:
> I recently noticed this problem on the Radxa Rock board. I'm not
> sure how this has ever worked on other platforms, though. I can
> only receive broadcast packets without configuring the address.
> 
> Running ifconfig eth0 hw ether XYZ or applying the patch fixes
> the problem for me.

Our rcS script would always do a ifconfig hw, hence we didn't run into this. We
have used this driver in one of our FPGA boards for several years.

-Vineet
