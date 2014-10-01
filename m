Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaJAU1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:27:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39003 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaJAU1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:27:53 -0400
Date: Wed, 1 Oct 2014 16:27:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Arianna Avanzini <avanzini.arianna@gmail.com>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, bob.liu@oracle.com, felipe.franciosi@citrix.com,
        axboe@fb.com
Subject: Re: [PATCH RFC v2 0/5] Multi-queue support for xen-blkfront and
 xen-blkback
Message-ID: <20141001202721.GF12581@laptop.dumpdata.com>
References: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any comments or suggestions are more than welcome.

Hey Arianna,

Thank you for posting this patchset. I've gone over each patchset and the design
looks quite sound. There are just a some required changes mentioned by Christopher,
David, and me in regards to the different uses of APIs and such.

And I should on the next revision be able to review much quicker now that the
giant nexus of _everything_ (Xen 4.5 feature freeze, LinuxCon, tons of reviews,
internal bugs, etc) has slowed down.

Again, thank you for doing this work and posting the patchset!
