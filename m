Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab3LER10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:27:26 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:32770 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab3LER1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:27:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Thu, 05 Dec 2013 18:33:20 +0100
From: Stefan Agner <stefan@agner.ch>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: thierry.reding@gmail.com, dev@lynxeye.de, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] ARM: tegra: correct Colibri T20 regulator settings
In-Reply-To: <52A0B40B.7040903@wwwdotorg.org>
References: <cover.1386108712.git.stefan@agner.ch>
 <fc7440a2f4bf9ab95e47a911c0e0b3b6a2250356.1386108712.git.stefan@agner.ch>
 <52A0B40B.7040903@wwwdotorg.org>
Message-ID: <e2fe1d7b546e9f81fdd1ad225676e76e@agner.ch>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2013-12-05 18:12, schrieb Stephen Warren:
> On 12/03/2013 03:18 PM, Stefan Agner wrote:
>> Set the parent of the regulators LDO2 to LDO9 according to the
>> schematic. Set the base voltage to 3.3V, there is only 3.3V on the
>> module itself.
>>
>> Set the Core and CPU voltage to the specified voltages of 1.2V and
>> 1.0V respectivly.
>>
>> LDO6 should deliver 2.85V. The attached peripherals were not in
>> use so far.
> 
> Does this depend on patch 1/3 or 2/3, or can I apply it to the Tegra
> tree which doesn't include those patches?

This patch is independent from 1/3 and 2/3, so you can apply it to the
Tegra tree. The relevant DT change for 2/3 is included in 2/3...
