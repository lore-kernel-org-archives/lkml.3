Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab3CLWNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:13:43 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33115 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3CLWNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:13:42 -0400
Date: Tue, 12 Mar 2013 15:13:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mike Travis <travis@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Jason Wessel <jason.wessel@windriver.com>,
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
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 05/14] KDB: add more exports for supporting KDB modules
Message-ID: <20130312221336.GA25699@kroah.com>
References: <20130312193823.212544181@gulag1.americas.sgi.com>
 <20130312193824.025713118@gulag1.americas.sgi.com>
 <87obeo7530.fsf@xmission.com>
 <513FA625.2020300@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513FA625.2020300@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 03:03:17PM -0700, Mike Travis wrote:
> Let me see if I can understand the concept better.  By denying
> an external hardware vendor the use of KDB to support a significant
> piece of proprietary hardware on Linux, I furthering the interests
> of Linux and the community how?

Did SGI lawyers really agree to this patch?  I consider you running this
by them if you have any questions as to why we are objecting to this.
If, after discussing it with them, they still are asking for this
change, please resend it, with their signed-off-by: on it showing that
they really want this change.

greg k-h
