Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab3FSFyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:54:23 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38706 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab3FSFyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:54:21 -0400
X-Sasl-enc: yDkAxZjvLKwCnAHk4IATPHOj2+WWuqloX3/OOsK8WLI1 1371621260
Date: Tue, 18 Jun 2013 22:55:00 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
Message-ID: <20130619055500.GA5283@kroah.com>
References: <20130619153225.9ff68f0984bfa54333c4df10@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619153225.9ff68f0984bfa54333c4df10@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 03:32:25PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/base/firmware_class.c between commit 875979368eb4 ("firmware
> loader: fix use-after-free by double abort") from the driver-core.current
> tree and commit fe304143b0c3 ("firmware: Avoid deadlock of usermodehelper
> lock at shutdown") from the driver-core tree.
> 
> I fixed it up (more may be required - see below) and can carry the fix as
> necessary (no action is required).

Thanks, the merge looks correct, Ming, any objection?

greg k-h
