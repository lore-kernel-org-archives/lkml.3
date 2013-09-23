Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3IWM7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:59:45 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:42004 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3IWM7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:59:44 -0400
Message-ID: <524039E0.2060205@cogentembedded.com>
Date: Mon, 23 Sep 2013 16:53:52 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Roger Quadros <rogerq@ti.com>, balbi@ti.com, bcousson@baylibre.com,
        tony@atomide.com, balajitk@ti.com, kishon@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 08/15] ata: ahci_platform: Manage SATA PHY
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <1379595943-14622-9-git-send-email-rogerq@ti.com> <20130922165817.GD30946@htj.dyndns.org> <523F35E4.6050707@cogentembedded.com> <20130922215107.GD27616@mtj.dyndns.org>
In-Reply-To: <20130922215107.GD27616@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-09-2013 1:51, Tejun Heo wrote:

>>     Not sure why you asked -- I'm not using this driver, neither I'm

> Well, you have better grip of what's going on in the embedded world
> than me.  I'm mostly curious whether adding dependency on PHY is okay.

    This driver already supports optional clock, the optional PHY support
seems analogous.

> Thanks.

WBR, Sergei

