Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaKYSrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:47:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaKYSrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:47:19 -0500
Date: Tue, 25 Nov 2014 19:47:14 +0100
From: Borislav Petkov <bp@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Richard Hendershot <rshendershot@mchsi.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
Message-ID: <20141125184714.GD4128@pd.tnic>
References: <20141119205150.700188369@linuxfoundation.org>
 <20141119205153.916605840@linuxfoundation.org>
 <5474C67A.7040200@oracle.com>
 <20141125184501.GA3461@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141125184501.GA3461@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 10:45:01AM -0800, Greg Kroah-Hartman wrote:
> Does that mean it is also broken in Linus's tree?

Should be.

> If so, please fix it there.

Gladly, if Boris would share some more info as to why it breaks the PV
gunk...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
