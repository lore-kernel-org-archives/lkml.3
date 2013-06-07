Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3FGOoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:44:07 -0400
Received: from www.xora.org.uk ([80.68.91.202]:58061 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3FGOoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:44:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Jun 2013 15:44:00 +0100
From: gg@slimlogic.co.uk
To: Mark Brown <broonie@kernel.org>
Cc: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, sameo@linux.intel.com, lgirdwood@gmail.com,
        balbi@ti.com, peter.ujfalusi@ti.com, t-kristo@ti.com, tony@atomide.com
Subject: Re: [RFC v1] MFD: Change TWL6025 references to TWL6032
In-Reply-To: <20130607143649.GS31367@sirena.org.uk>
References: <1370602390-12306-1-git-send-email-oleksandr.kozaruk@ti.com>
 <20130607143649.GS31367@sirena.org.uk>
Message-ID: <c73c260b90be6e1640a430e8cbba6cac@slimlogic.co.uk>
User-Agent: Roundcube Webmail/0.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-06-07 15:36, Mark Brown wrote:
> On Fri, Jun 07, 2013 at 01:53:10PM +0300, Oleksandr Kozaruk wrote:
>> From: Graeme Gregory <gg@slimlogic.co.uk>
>> 
>> The TWL6025 was never released beyond sample form and was replaced by
>> the PhoenixLite range of chips - TWL6032. Change the references to
>> reference the TWL6032 class and name the registers to twl6032 in line 
>> with
>> an actual released chip name to avoid confusion.
>> 
>> Currently there is no users of TWL6025 in the code.
> 
> Given that the chip exists even if not widely distributed it seems as
> well to keep the twl6025 references in there at least in the device ID
> table - it won't do any harm to people using the twl6032 name and might
> help someone who happens to pick up an old board for whatever reason.

I do not think any "old boards" exist, it really was a limited run!

Graeme

