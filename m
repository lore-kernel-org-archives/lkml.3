Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab3G3Txh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:53:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27464 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab3G3Txg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:53:36 -0400
Date: Tue, 30 Jul 2013 15:53:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: sfr@canb.auug.org.au, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Replace in linux-next the xen, xen-two, xen-arm with xen/tip.git
 tree instead.
Message-ID: <20130730195316.GA12124@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I was wondering if it would be possible to remove from linux-next
the three xen trees and instead use a combined tree, similar to the
x86 tip (so the various maintainers share it)?

The ones that would be removed are:

xen		git	git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git#upstream/xen
xen-two		git	git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git#linux-next
xen-arm		git	git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git#linux-next

And instead it would be pulled from:

xen-tip		git	git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git#linux-next

I presume you need Ack's from all of us (so Jeremy and Stefano) so CC-ing them here.

And Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
