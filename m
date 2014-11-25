Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbaKYSn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:43:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbaKYSn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:43:56 -0500
Date: Tue, 25 Nov 2014 19:43:51 +0100
From: Borislav Petkov <bp@suse.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
Message-ID: <20141125184351.GC4128@pd.tnic>
References: <20141119205150.700188369@linuxfoundation.org>
 <20141119205153.916605840@linuxfoundation.org>
 <5474C67A.7040200@oracle.com>
 <20141125182410.GB4128@pd.tnic>
 <5474CDCE.6040000@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5474CDCE.6040000@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 01:43:26PM -0500, Boris Ostrovsky wrote:
> I don't think this routine is called on PV.

They're either both called or none is. At least on baremetal, that is.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
