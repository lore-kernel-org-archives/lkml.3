Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab3GUTCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 15:02:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54259 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab3GUTCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 15:02:22 -0400
Date: Sun, 21 Jul 2013 21:02:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
Cc: Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: lockdep warning in edac_create_sysfs_mci_device
Message-ID: <20130721190212.GA31470@pd.tnic>
References: <20130721144819.GJ24717@sanechka.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130721144819.GJ24717@sanechka.spb.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 06:48:20PM +0400, Alexandra N. Kossovsky wrote:
> Hello.
> 
> I am running Linux-3.10.0 with lockdep and see following warning
> in edac_create_sysfs_mci_device:
> 
> [   21.596585] BUG: key ffff8801a80ae470 not in .data!

A fix is on the way:

http://marc.info/?l=linux-edac&m=137422971614927&w=2

Thanks for the report.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
