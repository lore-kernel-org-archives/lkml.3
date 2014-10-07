Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaJGRLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:11:20 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:64342 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbaJGRLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:11:16 -0400
Date: Tue, 7 Oct 2014 19:11:09 +0200
From: Rabin Vincent <rabin@rab.in>
To: Oussama Ghorbel <ghorbel@pivasoftware.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, rogerq@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] phy: omap-usb2: Enable runtime PM of omap-usb2 phy
 properly
Message-ID: <20141007171109.GA2297@debian>
References: <20141006194418.GA399@debian>
 <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 12:02:51PM +0100, Oussama Ghorbel wrote:
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

Tested-by: Rabin Vincent <rabin@rab.in>

Thanks.
