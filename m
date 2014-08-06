Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaHFUPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:15:06 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46950 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaHFUPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:15:03 -0400
Date: Wed, 6 Aug 2014 13:15:00 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: devicetree@vger.kernel.org, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] of/irq: lookup 'interrupts-extended' property first
Message-ID: <20140806201500.GP3711@ld-irv-0074>
References: <1407355347-30286-1-git-send-email-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407355347-30286-1-git-send-email-f.fainelli@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 01:02:27PM -0700, Florian Fainelli wrote:
> In case the Device Tree blob passed by the boot agent supplies both an
> 'interrupts-extended' and an 'interrupts' property in order to allow for
> older kernels to be usable, prefer the new-style 'interrupts-extended'
> property which conveys a lot more information.
> 
> This allows us to have bootloaders willingly maintaining backwards
> compatibility with older kernels without entirely deprecating the
> 'interrupts' property.
> 
> Update the bindings documentation to describe a situation where both the
> 'interrupts-extended' and the 'interrupts' property are present, and
> which one takes precedence over the other.
> 
> Acked-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Might we add this?

Cc: <stable@vger.kernel.org> # 3.13+

Brian
