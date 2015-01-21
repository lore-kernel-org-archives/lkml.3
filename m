Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbbAUPTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:19:43 -0500
Received: from imap.thunk.org ([74.207.234.97]:53250 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbbAUPTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:19:35 -0500
Date: Wed, 21 Jan 2015 10:19:13 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Daniel Mack <daniel@zonque.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de,
        ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no,
        jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, dh.herrmann@gmail.com, tixxdz@opendz.org,
        Johannes Stezenbach <js@sig21.net>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Message-ID: <20150121151913.GA4798@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
	Daniel Mack <daniel@zonque.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de,
	ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no,
	jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, dh.herrmann@gmail.com,
	tixxdz@opendz.org, Johannes Stezenbach <js@sig21.net>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com>
 <54BE9D08.7010804@zonque.org>
 <54BF805B.4000609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BF805B.4000609@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 11:32:59AM +0100, Michael Kerrisk (man-pages) wrote:
> It's rather an optional driver than a core kernel feature.
> 
> Given the various things that I've seen said about kdbus, the
> preceding sentence makes little sense to me:
> 
> * kdbus will be the framework supporting user-space D-Bus in the
>   future, and also used by systemd, and so on pretty much every 
>   desktop system.

I have to agree with Michael here; it's really, **really**
disengenuous to say that that if you don't want kdbus, you can just
#ifconfig it out.  The fact that it systemd will be using it means
that it will very shortly become a core kernel feature which is
absolutely mandatory.  Sure, maybe it can be configured out for "tiny
kernels", just as in theory we can configure out the VM system for
really tiny embedded systems.  But we should be treating this as
something that is not optional, because the reality is that's the way
it's going to be in very short order.  So if that means to use proper
system calls instead of ioctls, we should do that.

       	     	     		   - Ted
