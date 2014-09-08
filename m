Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaIHN6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:58:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33554 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbaIHN6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:58:30 -0400
Date: Mon, 8 Sep 2014 15:58:11 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH] xen/balloon: Remove unused pr_fmt() macro
Message-ID: <20140908135811.GI3459@olila.local.net-space.pl>
References: <1410182638-18820-1-git-send-email-daniel.kiper@oracle.com>
 <540DAE71.4060902@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540DAE71.4060902@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 02:26:09PM +0100, David Vrabel wrote:
> On 08/09/14 14:23, Daniel Kiper wrote:
> > Remove unused pr_fmt() macro. Additionally, remove surplus empty
> > lines which left after earlier various fixes and cleanups.
>
> A patch in the 3.17 queue uses this.

Hmmm... Which one? I am not able to find anything relevant in xen/tip.
Am I missing something?

Daniel
