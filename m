Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbaIIL3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:29:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22482 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaIIL3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:29:24 -0400
Date: Tue, 9 Sep 2014 13:28:47 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, mingo@redhat.com, hpa@zytor.com,
        boris.ostrovsky@oracle.com, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] xen/efi: Directly include needed headers
Message-ID: <20140909112847.GM3459@olila.local.net-space.pl>
References: <1410182538-18783-1-git-send-email-daniel.kiper@oracle.com>
 <540DE8F0.8040303@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540DE8F0.8040303@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 06:35:44PM +0100, David Vrabel wrote:
> On 08/09/14 14:22, Daniel Kiper wrote:
> > I discovered that some needed stuff is defined/declared in headers
> > which are not included directly. Currently it works but if somebody
> > remove required headers from currently included headers then build
> > will break. So, just in case directly include all needed headers.
>
> Seems rather pointless, but harmless.
>
> Applied to devel/for-linus-3.18

Thanks.

Daniel
