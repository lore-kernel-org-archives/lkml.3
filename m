Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3IWHiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:38:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37274 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab3IWHiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:38:09 -0400
Message-ID: <523FEFC2.801@ti.com>
Date: Mon, 23 Sep 2013 10:37:38 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, <balbi@ti.com>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <balajitk@ti.com>,
        <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [RFC PATCH 08/15] ata: ahci_platform: Manage SATA PHY
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <1379595943-14622-9-git-send-email-rogerq@ti.com> <20130922165817.GD30946@htj.dyndns.org> <523F35E4.6050707@cogentembedded.com> <20130922215107.GD27616@mtj.dyndns.org>
In-Reply-To: <20130922215107.GD27616@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 09/23/2013 12:51 AM, Tejun Heo wrote:
> Hello,
> 
> On Sun, Sep 22, 2013 at 10:24:36PM +0400, Sergei Shtylyov wrote:
>>    Not sure why you asked -- I'm not using this driver, neither I'm
> 
> Well, you have better grip of what's going on in the embedded world
> than me.  I'm mostly curious whether adding dependency on PHY is okay.
> 

There is no hard dependency on presence of PHY. The driver will continue
as usual if devm_phy_get() fails.
I hope selecting GENERIC_PHY in Kconfig is not an issue.

cheers,
-roger
