Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaKEIdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:33:39 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:61734 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbaKEIdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:33:36 -0500
Message-ID: <1415176413.20372.206.camel@x220>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Wed, 05 Nov 2014 09:33:33 +0100
In-Reply-To: <20141105043030.GB10613@kroah.com>
References: <20141105151825.26c53948@canb.auug.org.au>
	 <20141105043030.GB10613@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Nov 2014 08:33:33.0485 (UTC) FILETIME=[2F726DD0:01CFF8D3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 20:30 -0800, Greg KH wrote:
> On Wed, Nov 05, 2014 at 03:18:25PM +1100, Stephen Rothwell wrote: 
> > Today's linux-next merge of the usb tree got a conflict in
> > drivers/usb/host/Kconfig between commit cd6e245a2d06 ("usb: Remove
> > references to non-existent PLAT_S5P symbol") from the usb.current tree
> > and commit dd3cf17488b1 ("usb: host: Remove optional dependencies on
> > PLAT_S5P") from the usb tree.
> > 
> > I fixed it up (I used the usb tree version) and can carry the fix as
> > necessary (no action is required).
> 
> That's the correct fix, thanks for doing that.

Shouldn't that be the other way round? I thought we would choose
Sylwester's commit from the usb.current tree over my commit from the usb
tree. Or will Sylwester's commit end up in linux-next through yet
another usb tree?


Paul Bolle

