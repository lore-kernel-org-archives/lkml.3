Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaBZXRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:17:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53345 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaBZXRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:17:35 -0500
Date: Wed, 26 Feb 2014 15:19:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Jiri Slaby <jslaby@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, David Miller <davem@davemloft.net>
Subject: 3.12-stable kernel tree being taken over by Jiri Slaby
Message-ID: <20140226231910.GA8789@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I hinted at in my kernel summit talk about the stable kernel tree, we
have a sucker^Wvolunteer who has stepped up to take over the longterm
maintenance of the 3.12 stable kernel tree.

Jiri Slaby will be doing this work, for how ever long he wants to do it.
I'll still be doing the final releases to kernel.org, like I do for 3.2,
but Jiri will be doing the collecting of patches and other real work
involved in it, including the announcements for its release.

The kernel.org page has already been updated with this information:
	https://www.kernel.org/category/releases.html

If anyone has any questions about this, please let me know.

David, I don't know if you want to keep doing 3.12-networking patches or
not, I'll let you work that out with Jiri directly.

thanks,

greg k-h
