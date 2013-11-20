Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3KTAaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:30:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3KTAaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:30:10 -0500
Date: Tue, 19 Nov 2013 16:30:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org, "# .39.x" <stable@kernel.org>
Subject: Re: [PATCH] n_tty: Ensure reader restarts worker for next reader
Message-ID: <20131120003032.GA27825@kroah.com>
References: <20131017211236.GA6155@kroah.com>
 <1383850796-24300-1-git-send-email-peter@hurleysoftware.com>
 <CA+55aFwYps=q14pQ04yWYThFwi3NnR__MeggU8N3M4Q0vrk+nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwYps=q14pQ04yWYThFwi3NnR__MeggU8N3M4Q0vrk+nQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 04:21:54PM -0800, Linus Torvalds wrote:
> Greg,
>  what happened to this patch? Is it still waiting in some random tree
> of yours, or did it get lost?

I was waiting for 3.13-rc1 to be out to populate my trees and then send
it on to you.

But if you want to take it now, great, I have no objection, otherwise I
was going to wait till next week.

greg k-h
