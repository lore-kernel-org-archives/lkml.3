Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266Ab3GaQg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:36:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51107 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760170Ab3GaQgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:36:25 -0400
Date: Wed, 31 Jul 2013 18:36:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: i915 backlight
Message-ID: <20130731163623.GD4724@pd.tnic>
References: <20130731162252.GC4724@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130731162252.GC4724@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 06:22:52PM +0200, Borislav Petkov wrote:
> Dudes,
> 
> has anyone already reported this (happens on Linus of today +
> tip/master):

Oh, one more thing: I can't control the backlight anymore on this x230
with the Fn-Fx keys and this is most probably related to that recent
backlight revert story. If there is a new approach I can test, please
let me know.

Btw, it worked before on this machine with "acpi_backlight=vendor" on
the cmdline.

Thanks a lot.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
