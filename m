Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaHYHtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:49:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39142 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbaHYHtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:49:13 -0400
Date: Mon, 25 Aug 2014 09:49:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac, amd64_edac: Modify usage of
 amd64_read_dct_pci_cfg()
Message-ID: <20140825074911.GA14365@nazgul.tnic>
References: <1408659586-4736-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20140825054339.GA13911@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140825054339.GA13911@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 07:43:39AM +0200, Borislav Petkov wrote:
> This is almost unreadable now with all the family checks everywhere.
> You need to hide all that per-family logic

And while you're at it, we're caching all required family info in the
pvt, see per_family_init(), no need for using boot_cpu_data.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
