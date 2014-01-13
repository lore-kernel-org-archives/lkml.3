Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaAMNBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:01:01 -0500
Received: from smtp.citrix.com ([66.165.176.89]:2089 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbaAMNA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:00:57 -0500
X-IronPort-AV: E=Sophos;i="4.95,653,1384300800"; 
   d="scan'208";a="92283449"
Message-ID: <1389618054.13654.57.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v2] xen-blkfront: remove type check from
 blkfront_setup_discard
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: Olaf Hering <olaf@aepfle.de>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <xen-devel@lists.xen.org>
Date: Mon, 13 Jan 2014 13:00:54 +0000
In-Reply-To: <52D3EB5F02000078001130B5@nat28.tlf.novell.com>
References: <1389608052-7139-1-git-send-email-olaf@aepfle.de>
	 <52D3DAEE0200007800112FD4@nat28.tlf.novell.com>
	 <20140113120131.GA15623@aepfle.de>
	 <52D3EB5F02000078001130B5@nat28.tlf.novell.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 12:34 +0000, Jan Beulich wrote:
> >>> On 13.01.14 at 13:01, Olaf Hering <olaf@aepfle.de> wrote:
> > On Mon, Jan 13, Jan Beulich wrote:
> > 
> >> You can't do this in one go - the first two and the last one may be
> >> set independently (and are independent in their meaning), and
> >> hence need to be queried independently (xenbus_gather() fails
> >> on the first absent value).
> > 
> > Yes, thats the purpose. Since the properties are required its an all or
> > nothing thing. If they are truly optional then blkif.h should be updated
> > to say that.
> 
> They _are_ optional.

But is it true that either they are all present or they are all absent?

Ian.


