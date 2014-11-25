Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaLBHlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:41:18 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54374 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaLBHlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:41:17 -0500
Date: Tue, 25 Nov 2014 14:50:53 -0800
From: Darren Hart <dvhart@infradead.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: platform-driver-x86@vger.kernel.org, Azael Avalos <coproscefalo@gmail.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] toshiba-acpi: Add missing ID (TOS6207)
Message-ID: <20141125225053.GE116670@vmdeb7>
References: <1415574714-3847-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415574714-3847-1-git-send-email-linux@rainbow-software.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 12:11:54AM +0100, Ondrej Zary wrote:
> toshiba-acpi was always missing TOS6207 ID so it did not load automatically
> on some laptops (such as Portege R100). But it worked fine if loaded manually.
> Commit 135740de7764 ("toshiba_acpi: Convert to use acpi_driver") broke that
> and the driver does not work even when loaded manually since then.
> 
> Add TOS6207 ID to fix it.
> 
> Tested on Toshiba Portege R100.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Queued, thanks!

-- 
Darren Hart
Intel Open Source Technology Center
