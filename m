Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbbAIVlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:41:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbbAIVlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:41:07 -0500
Date: Fri, 9 Jan 2015 13:41:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Francesco Ruggeri <fruggeri@aristanetworks.com>,
        Francesco Ruggeri <fruggeri@arista.com>
Subject: Re: [PATCH] Revert "tty: Fix pty master poll() after slave closes v2"
Message-ID: <20150109214106.GA7952@kroah.com>
References: <1419941829-6536-1-git-send-email-peter@hurleysoftware.com>
 <54A29B0A.3060707@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A29B0A.3060707@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 07:31:06AM -0500, Peter Hurley wrote:
> On 12/30/2014 07:17 AM, Peter Hurley wrote:
> > This reverts commit c4dc304677e8d566572c4738d95c48be150c6606.
> > This fix is superseded by commit 52bce7f8d4fc633c9a9d0646eef58ba6ae9a3b73,
> > 'pty, n_tty: Simplify input processing on final close'.
> > 
> > The final close now waits for input processing to complete before
> > destroying the pty, so poll() does not need to special case this
> > condition.
> 
> Greg,
> 
> As noted in this commit log, commit c4dc304677e8d566572c4738d95c48be150c6606,
> 'tty: Fix pty master poll() after slave closes v2', is not required
> after commit 52bce7f8d4fc633c9a9d0646eef58ba6ae9a3b73,
> 'pty, n_tty: Simplify input processing on final close'
> 
> However, 'tty: Fix pty master poll() after slave closes v2' is appropriate
> for stable back to v3.12.

I don't understand, what needs to go to a stable tree and what doesn't?

confused,

greg k-h
