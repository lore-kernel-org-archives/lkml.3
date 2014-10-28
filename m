Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaJ1B6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 21:58:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaJ1B6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 21:58:36 -0400
Date: Tue, 28 Oct 2014 09:57:24 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 09/11] tty: ipwireless: Fix probable mask then right
 shift defects
Message-ID: <20141028015724.GB23627@kroah.com>
References: <cover.1414387334.git.joe@perches.com>
 <5f61fec0dbc7d50715800c94b19db5914b1af610.1414387334.git.joe@perches.com>
 <alpine.LNX.2.00.1410271356050.20256@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410271356050.20256@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 03:17:28PM +0100, Jiri Kosina wrote:
> On Sun, 26 Oct 2014, Joe Perches wrote:
> 
> > Precedence of & and >> is not the same and is not left to right.
> > shift has higher precedence and should be done after the mask.
> > 
> > Add parentheses around the masks.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> 
> Greg, can you take this through your char/misc tree, please?

Ok, will do, give me a week or so to catch up on pending patches.

greg k-h
