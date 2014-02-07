Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaBGKov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:44:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45985 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaBGKot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:44:49 -0500
Message-ID: <52F4B8FD.1030106@ti.com>
Date: Fri, 7 Feb 2014 12:44:13 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, <kishon@ti.com>,
        Tejun Heo <tj@kernel.org>, <balbi@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <balajitk@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 08/15] ata: ahci_platform: Manage SATA PHY
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <5240492D.6060204@ti.com> <52F4B682.2000201@ti.com> <463926864.ALblgUKdgH@wuerfel>
In-Reply-To: <463926864.ALblgUKdgH@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 12:39 PM, Arnd Bergmann wrote:
> On Friday 07 February 2014 12:33:38 Roger Quadros wrote:
>>
>> This means we need to make CONFIG_SATA_AHCI_PLATFORM depend on CONFIG_GENERIC_PHY or
>> select it.
>>
>> OR
>>
>> Generic PHY layer must be fixed so that the API's are always built in.
>>
>> What is the better option? I believe making the PHY API's always built in is the better option.
>>
> 
> CONFIG_SATA_AHCI_PLATFORM should do
> 
> 	"depends on CONFIG_GENERIC_PHY || !CONFIG_GENERIC_PHY"
> 
> which is the Kconfig way of saying that if CONFIG_GENERIC_PHY is a module,
> CONFIG_SATA_AHCI_PLATFORM needs to be a module as well.
> 

Ah, that's neat. Thanks :).

cheers,
-roger

