Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaFKJpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:45:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59601 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaFKJpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:45:11 -0400
Message-ID: <539824F9.6050302@ti.com>
Date: Wed, 11 Jun 2014 15:14:25 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>, <hdegoede@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] phy: sun4i: depend on RESET_CONTROLLER
References: <1400871088-16894-1-git-send-email-maxime.ripard@free-electrons.com> <20140611091035.GD4254@lukather>
In-Reply-To: <20140611091035.GD4254@lukather>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 11 June 2014 02:40 PM, Maxime Ripard wrote:
> Hi Kishon,
> 
> On Fri, May 23, 2014 at 08:51:28PM +0200, Maxime Ripard wrote:
>> The driver depend on the reset framework in a mandatory way. Make sure
>> reset_control_get is defined by adding this dependency in Kconfig
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> Reported-by: Arnd Bergmann <arnd@arndb.de>
> 
> Ping?

Will queue once -rc1 is tagged.

Cheers
Kishon

> 
> Maxime
> 
