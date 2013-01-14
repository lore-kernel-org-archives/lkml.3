Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab3ANXF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:05:26 -0500
Received: from c60.cesmail.net ([216.154.195.49]:28839 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab3ANXFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:05:25 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2013 18:05:25 EST
Date: Mon, 14 Jan 2013 17:55:33 -0500
From: Pavel Roskin <proski@gnu.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Daniel Drake <dsd@laptop.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-firmware: add MISSING file
Message-ID: <20130114175533.4f184cd3@mj>
In-Reply-To: <CAFLxGvxTenzaaypsUz6pYmjiyEeUtkNGDKwBNeAVFUb5ZZgonQ@mail.gmail.com>
References: <1358030383-15609-1-git-send-email-xose.vazquez@gmail.com>
	<CAFLxGvxTenzaaypsUz6pYmjiyEeUtkNGDKwBNeAVFUb5ZZgonQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2013 00:09:46 +0100
richard -rw- weinberger <richard.weinberger@gmail.com> wrote:

> > +This file attempts to document the reason why a firmware is not
> > present +in this bundle.
> 
> From the user's point of view this not really helpful.
> Wouldn't a in-kernel table of known but missing firmware files make
> more sense? The kernel could write a log like "Yeah, I know this
> firmware but sadly I don't have it because of ..."

The firmware file may be absent on the system even if it's in the
linux-firmware tree.  Conversely, the firmware may be present on the
system but not in the linux-firmware tree.

The kernel doesn't know whether the firmware is missing due to
licensing issues or due to misconfiguration.  The kernel cannot know
that.  And I don't think the kernel should include as much information
as the MISSING file would include.

-- 
Regards,
Pavel Roskin
