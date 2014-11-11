Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaKKPuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:50:20 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:39566 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaKKPuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:50:16 -0500
Date: Tue, 11 Nov 2014 15:49:59 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH -next v2 21/26] pty: Don't drop pty master tty lock to
 hangup slave
Message-ID: <20141111154959.65f5109e@alan.etchedpixels.co.uk>
In-Reply-To: <1415207589-15967-22-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
	<1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
	<1415207589-15967-22-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Nov 2014 12:13:04 -0500
Peter Hurley <peter@hurleysoftware.com> wrote:

> With the revised tty lock order and lockdep annotation, claiming
> the pty slave lock is now safe while still holding the pty master lock.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

Reviewed-by: Alan Cox <alan@linux.intel.com>

