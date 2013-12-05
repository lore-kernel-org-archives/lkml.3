Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab3LERMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:12:49 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33096 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab3LERMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:12:47 -0500
Message-ID: <52A0B40B.7040903@wwwdotorg.org>
Date: Thu, 05 Dec 2013 10:12:43 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, thierry.reding@gmail.com, dev@lynxeye.de,
        lee.jones@linaro.org, lgirdwood@gmail.com, broonie@kernel.org
CC: kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] ARM: tegra: correct Colibri T20 regulator settings
References: <cover.1386108712.git.stefan@agner.ch> <fc7440a2f4bf9ab95e47a911c0e0b3b6a2250356.1386108712.git.stefan@agner.ch>
In-Reply-To: <fc7440a2f4bf9ab95e47a911c0e0b3b6a2250356.1386108712.git.stefan@agner.ch>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 03:18 PM, Stefan Agner wrote:
> Set the parent of the regulators LDO2 to LDO9 according to the
> schematic. Set the base voltage to 3.3V, there is only 3.3V on the
> module itself.
> 
> Set the Core and CPU voltage to the specified voltages of 1.2V and
> 1.0V respectivly.
> 
> LDO6 should deliver 2.85V. The attached peripherals were not in
> use so far.

Does this depend on patch 1/3 or 2/3, or can I apply it to the Tegra
tree which doesn't include those patches?

If this does depend on patch 1/3 or 2/3... this patch feels a bit big to
apply to the MFD tree. Perhaps patch 1/3 and 2/3 could be applied alone
to a topic branch in the MFD tree so I can merge that into the Tegra
tree in order to apply this?
