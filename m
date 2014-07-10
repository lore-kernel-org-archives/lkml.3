Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaGJQMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:12:34 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52139 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882AbaGJQMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:12:32 -0400
X-Sasl-enc: z5igM7I/POZ3IF+JITT5N8BXJyzjWkeQj/Anr/Sk/Z7W 1405008746
Date: Thu, 10 Jul 2014 09:12:05 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sachin Kamat <sachin.kamat@samsung.com>
Subject: Re: linux-next: manual merge of the akpm tree with the staging tree
Message-ID: <20140710161205.GB20239@kroah.com>
References: <20140710162750.60496f52@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140710162750.60496f52@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 04:27:50PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> drivers/staging/emxx_udc/emxx_udc.c between commit 6de2a1a7b9e2
> ("staging: emxx_udc: Fix build error") from the staging tree and commit
> "drivers/staging/emxx_udc/emxx_udc.c: replace strict_strto() with
> kstrto()" from the akpm tree.
> 
> I fixed it up (I just used the version from the staging tree) and can
> carry the fix as necessary (no action is required).

Sounds good, thanks.

greg k-h
