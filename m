Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3G3U0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:26:36 -0400
Received: from claw.goop.org ([74.207.240.146]:42676 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523Ab3G3U0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:26:35 -0400
Message-ID: <51F82179.2080405@goop.org>
Date: Tue, 30 Jul 2013 13:26:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: sfr@canb.auug.org.au, xen-devel@lists.xensource.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: Replace in linux-next the xen, xen-two, xen-arm with xen/tip.git
 tree instead.
References: <20130730195316.GA12124@phenom.dumpdata.com>
In-Reply-To: <20130730195316.GA12124@phenom.dumpdata.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 12:53 PM, Konrad Rzeszutek Wilk wrote:
> Hey,
>
> I was wondering if it would be possible to remove from linux-next
> the three xen trees and instead use a combined tree, similar to the
> x86 tip (so the various maintainers share it)?
>
> The ones that would be removed are:
>
> xen		git	git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git#upstream/xen
> xen-two		git	git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git#linux-next
> xen-arm		git	git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git#linux-next
>
> And instead it would be pulled from:
>
> xen-tip		git	git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git#linux-next
>
> I presume you need Ack's from all of us (so Jeremy and Stefano) so CC-ing them here.
>
> And Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>

Ack from me.

    J
