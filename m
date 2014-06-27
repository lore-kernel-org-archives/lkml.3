Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaF0PCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:02:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47881 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbaF0PCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:02:03 -0400
Date: Fri, 27 Jun 2014 17:01:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86-ml <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] 2 RAS fixes for 3.17, refreshed
Message-ID: <20140627150155.GG23153@pd.tnic>
References: <20140622164603.GA3385@pd.tnic>
 <20140624132439.GH4439@pd.tnic>
 <20140624132701.GB28885@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140624132701.GB28885@laptop.dumpdata.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 09:27:01AM -0400, Konrad Rzeszutek Wilk wrote:
> Isn't that one a regression that was introduced in 3.16?

Hrrm, BorisO, you said misc_register would often fail in xen, is that
correct? Because if so, we added the error check to misc_register in
3.16 so the mcheck_init_device fix would have to go in now.

Right?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
