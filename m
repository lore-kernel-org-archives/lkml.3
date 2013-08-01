Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3HAQoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:44:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45848 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3HAQoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:44:12 -0400
Message-ID: <51FA9056.7010104@wwwdotorg.org>
Date: Thu, 01 Aug 2013 10:44:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: akpm@linux-foundation.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, gg@slimlogic.co.uk, kishon@ti.com,
        swarren@nvidia.com, pawel.moll@arm.com, Mark.Rutland@arm.com,
        ian.campbell@citrix.com, broonie@kernel.org
Subject: Re: [PATCH V2] drivers/rtc/rtc-palmas.c: support for backup battery
 charging
References: <1375367471-29908-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1375367471-29908-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 08:31 AM, Laxman Dewangan wrote:
> Palmas series device like TPS65913, TPS80036 supports the backup battery
> for powering the RTC when no other energy source is available.
> 
> The backup battery is optional, connected to the VBACKUP pin, and can be
> nonrechargeable or rechargeable. The rechargeable battery can be charged
> from the system supply using the backup battery charger.
> 
> Add support for enabling charging of this backup battery.  Also add the DT
> binding document and the new properties to have this support.

> diff --git a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt

> +Palmas RTC controller bindings
> +
> +Required properties:
> +- compatible:
> +  - "ti,palmas-rtc" for palma series of the RTC controller

Nit: Here is another Palma -vs- Palmas inconsistency. What is the
correct name for the device; Palma or Palmas? Either way, the should
always have an initial capital letter in free-form text (i.e. but not in
property/node names).

Aside from that, the binding looks fine to me now, assuming it's fully
describing the RTC module's functionality. So, the binding,

Reviewed-by: Stephen Warren <swarren@nvidia.com>

