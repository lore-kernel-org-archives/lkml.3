Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab3HSJTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:19:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab3HSJS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:18:58 -0400
Date: Mon, 19 Aug 2013 10:18:39 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: viro@zeniv.linux.org.uk, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: ubd: Add REQ_FLUSH suppport
Message-ID: <20130819091839.GX5918@redhat.com>
References: <1376777374-17521-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376777374-17521-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 12:09:34AM +0200, Richard Weinberger wrote:
> UML's block device driver does not support write barriers,
> to support this this patch adds REQ_FLUSH suppport.
> Every time the block layer sends a REQ_FLUSH we fsync() now
> our backing file to guarantee data consistency.

This fixes the sync problem I saw before.  So:

Tested-by: Richard W.M. Jones <rjones@redhat.com>

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v
