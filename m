Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab3JOT2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:28:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab3JOT2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:28:33 -0400
Date: Tue, 15 Oct 2013 15:28:18 -0400
From: Dave Jones <davej@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Wong <normalperson@yhbt.net>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: epoll oops.
Message-ID: <20131015192818.GA32392@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Davide Libenzi <davidel@xmailserver.org>,
	Eric Wong <normalperson@yhbt.net>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Peter Hurley <peter@hurleysoftware.com>
References: <20131014154627.GA9525@redhat.com>
 <CA+55aFw64xTR7LXjo5OfUvRwDb9UF8EcfjguAbF0C3VsUXCecg@mail.gmail.com>
 <CA+55aFxOpT9YLf7WLM+SOsp5U2R1-Px0LiEsdqV0Adr897dOqQ@mail.gmail.com>
 <20131015154838.GA32271@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015154838.GA32271@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 05:48:38PM +0200, Oleg Nesterov wrote:
 > > Hmm? There might be other cases..
 > 
 > Yes.
 > 
 > Dave, perhaps you have vmcore?

afraid not. I probably should set up kdump on my test machines. I'll look into it.

thanks,

	Dave

