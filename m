Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3KSRW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:22:26 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:43557 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab3KSRWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:22:24 -0500
Date: Tue, 19 Nov 2013 18:22:06 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jason Baron <jbaron@akamai.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Florian Fainelli <florian@openwrt.org>,
        Shinya Kuribayashi <skuribay@ruby.dti.ne.jp>,
        Jayachandran C <jchandra@broadcom.com>,
        Ganesan Ramalingam <ganesanr@broadcom.com>
Subject: Re: [PATCH v2] panic: Make panic_timeout configurable
Message-ID: <20131119172205.GE10382@linux-mips.org>
References: <20131118210436.233B5202A@prod-mail-relay06.akamai.com>
 <20131119090211.GN10382@linux-mips.org>
 <528B9BC1.7090402@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528B9BC1.7090402@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 12:11:29PM -0500, Jason Baron wrote:

> > I propose to kill these overrides for sanity unless somebody comes up
> > with a good argument.  Patch below.
> > 
> 
> And so have the mips default be 0? IE drop the arch/mips/Kconfig bits from
> the patch I posted? (Which could of course be configured to a non-zero value
> by the user, if desired.)

Yes.

  Ralf
