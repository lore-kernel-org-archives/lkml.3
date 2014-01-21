Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaAUTGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:06:35 -0500
Received: from alcazar.beanwood.com ([70.85.129.230]:37880 "EHLO
	alcazar.beanwood.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaAUTG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:06:29 -0500
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jan 2014 14:06:29 EST
Date: Tue, 21 Jan 2014 10:57:35 -0800
From: Andrew Ayer <agwa@andrewayer.name>
To: Florian Weimer <fweimer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vfs: Add fchmodat4 syscall: fchmodat with flag
 argument
Message-Id: <20140121105735.56cc4ec41a6f20719a70d19e@andrewayer.name>
In-Reply-To: <52DE2208.9040908@redhat.com>
References: <1326419626-22568-1-git-send-email-agwa@andrewayer.name>
	<1326419626-22568-2-git-send-email-agwa@andrewayer.name>
	<52DE2208.9040908@redhat.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014 08:30:16 +0100
Florian Weimer <fweimer@redhat.com> wrote:

> On 01/13/2012 02:53 AM, Andrew Ayer wrote:
> > This adds a 4 argument version of fchmodat (fchmodat4) that
> > supports a flag argument, as specified by POSIX.  It supports
> > the same two flags as fchownat: AT_SYMLINK_NOFOLLOW and AT_EMPTY_PATH.
> 
> I don't think it's possible to emulate AT_EMPTY_PATH in user space, so I 
> wonder if this could be applied, and if not, why.  Thanks.

The original patch no longer applies because there were some
minor changes to fs/open.c.  I'll fix up the patch and send it in.

I too would very much like to see this applied, or to know why it can't
be.

Thanks,
Andrew
