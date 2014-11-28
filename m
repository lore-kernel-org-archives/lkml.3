Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbaK1RuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:50:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaK1RuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:50:14 -0500
Date: Fri, 28 Nov 2014 18:50:10 +0100
From: Borislav Petkov <bp@suse.de>
To: poeschel@lemonage.de
Cc: gregkh@linuxfoundation.org, santosh.shilimkar@ti.com, sandeep_n@ti.com,
        kheitke@codeaurora.org, johannes.thumshirn@men.de,
        andreas.noever@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/Kconfig: remove duplicate entry for soc
Message-ID: <20141128175010.GA13895@pd.tnic>
References: <1417183720-16767-1-git-send-email-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1417183720-16767-1-git-send-email-poeschel@lemonage.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 03:08:40PM +0100, poeschel@lemonage.de wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> For some reason there was the same menu entry in menuconfig twice. This
> trivial patch leaves the one that is older as is and removes the other
> entry.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
