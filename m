Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaJHISK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:18:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56887 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbaJHISI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:18:08 -0400
Message-ID: <5434F336.4040908@ti.com>
Date: Wed, 8 Oct 2014 11:17:58 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Oussama Ghorbel <ghorbel@pivasoftware.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
CC: Rabin Vincent <rabin@rab.in>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] phy: omap-usb2: Enable runtime PM of omap-usb2 phy
 properly
References: <20141006194418.GA399@debian> <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com>
In-Reply-To: <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oussama,

On 10/07/2014 02:02 PM, Oussama Ghorbel wrote:
> The USB OTG port does not work since v3.16 on omap platform.
> This is a regression introduced by the commit
> eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
>  and remove).
> This because the call to pm_runtime_enable() function is moved after the
> call to devm_phy_create() function, which has side effect since later in
> the subsequent calls of devm_phy_create() there is a check with
> pm_runtime_enabled() to configure few things.
> 
> Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>

Acked-by: Roger Quadros <rogerq@ti.com>

Could you please send the patch to
Cc: <stable@vger.kernel.org>        [3.16+]

That way it will get into 3.16 onwards. Thanks.

cheers,
-roger

