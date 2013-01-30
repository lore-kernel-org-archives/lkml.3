Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab3A3LsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:48:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3A3LsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:48:16 -0500
Date: Wed, 30 Jan 2013 12:46:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lingzhu Xiang <lxiang@redhat.com>, Roman Rakus <rrakus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: set_termios/set_termiox should not return
	-EINTR
Message-ID: <20130130114645.GA6622@redhat.com>
References: <20130129190720.GA28000@redhat.com> <20130129190741.GA28004@redhat.com> <51082470.2070601@suse.cz> <20130129194908.GA29480@redhat.com> <510846AB.8010900@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510846AB.8010900@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Jiri Slaby wrote:
>
> On 01/29/2013 08:49 PM, Oleg Nesterov wrote:
> >
> > Perhaps /bin/bash is buggy too, I do not know. Probably Roman and
> > Lingzhu can tell more.
>
> But I really want to hear more details here (the commit log deserves
> that). E.g. why it started causing problems right now.

I have no idea, I only saw the test-case yesterday.

Perhaps it never caused the problems before, or perhaps it was never
reported.

> The code is there
> like forever.

Sure. Lingzhu noticed bug on 2.6.32.

Oleg.

