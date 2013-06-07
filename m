Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3FGL41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:56:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab3FGL4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:56:25 -0400
Date: Fri, 7 Jun 2013 13:52:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Guy Streeter <streeter@redhat.com>,
        Eric Paris <eparis@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/1] audit: cleanup audit_log_start/wait_for_auditd
	mess
Message-ID: <20130607115204.GA707@redhat.com>
References: <20130603204559.GA21574@redhat.com> <20130603204620.GB21574@redhat.com> <20130606135555.15e649bccc02d8c738e71fa9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606135555.15e649bccc02d8c738e71fa9@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06, Andrew Morton wrote:
>
> On Mon, 3 Jun 2013 22:46:20 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > audit_log_start() tries to obfusticate the code/logic and
> > reimplements wait_event_timeout() in a very confusing way.
> >
> > Just change wait_for_auditd() to use wait_event_timeout()
> > and return bool.
> >
> > Also remove the unnecessary "ab = NULL" initialization.
>
> I would prefer that this be nicely tested - for a cosmetic thing I
> don't think it's worth the risk as-is.

OK, agreed. Please ignore.

Oleg.

