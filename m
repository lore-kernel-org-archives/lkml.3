Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3GISrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 14:47:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60689 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab3GISrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 14:47:39 -0400
Date: Tue, 9 Jul 2013 20:47:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: early microcode on amd is broken when no initramfs provided
Message-ID: <20130709184722.GA27570@pd.tnic>
References: <20130709183601.5d567a83@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130709183601.5d567a83@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 06:36:01PM +0200, Johannes Hirte wrote:
> When CONFIG_MICROCODE_EARLY is enabled on AMD but no initramfs is provided in the
> bootmanager (grub2), the system hangs here:

I'll take a look soonish if Jacob doesn't beat me to it.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
