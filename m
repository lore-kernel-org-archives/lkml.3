Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab3CLUXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:23:09 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65379 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab3CLUXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:23:07 -0400
Date: Tue, 12 Mar 2013 13:23:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Cong Wang <amwang@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 05/14] KDB: add more exports for supporting KDB modules
Message-ID: <20130312202303.GB6060@kroah.com>
References: <20130312193823.212544181@gulag1.americas.sgi.com>
 <20130312193824.025713118@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312193824.025713118@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 02:38:28PM -0500, Mike Travis wrote:
> This patch adds some important KDB functions to be externally
> usable by loadable KDB modules.

What modules would that be?  Are they in this patch series?

> Note that often drivers bring in KDB modules for debugging, and in the
> past KDB has not been limited to use by GPL only modules.

It always has been, when was the in-kernel code any other way?

> This patch restores KDB usefullness to non-GPL modules.

As Eric says, you can't just do this, sorry.

greg k-h
