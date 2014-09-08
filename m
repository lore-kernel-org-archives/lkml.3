Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaIHO1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:27:34 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43948 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaIHO1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:27:33 -0400
Date: Mon, 8 Sep 2014 16:27:17 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH] xen/balloon: Remove unused pr_fmt() macro
Message-ID: <20140908141408.GJ3459@olila.local.net-space.pl>
References: <1410182638-18820-1-git-send-email-daniel.kiper@oracle.com>
 <540DAE71.4060902@citrix.com>
 <20140908135811.GI3459@olila.local.net-space.pl>
 <540DB6B0.9000503@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540DB6B0.9000503@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 03:01:20PM +0100, David Vrabel wrote:
> On 08/09/14 14:58, Daniel Kiper wrote:
> > On Mon, Sep 08, 2014 at 02:26:09PM +0100, David Vrabel wrote:
> >> On 08/09/14 14:23, Daniel Kiper wrote:
> >>> Remove unused pr_fmt() macro. Additionally, remove surplus empty
> >>> lines which left after earlier various fixes and cleanups.
> >>
> >> A patch in the 3.17 queue uses this.
> >
> > Hmmm... Which one? I am not able to find anything relevant in xen/tip.
> > Am I missing something?
>
> The balloon driver already uses it.  It is used in the pr_info() and
> pr_warn() etc. macros.

Ahhh... OK, I see. We override default macro definition in include/linux/printk.h.
So, forget about that patch. Sorry for confusion.

Daniel
