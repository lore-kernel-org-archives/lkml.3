Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab3CLWCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:02:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:43184 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3CLWCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:02:23 -0400
Date: Tue, 12 Mar 2013 23:01:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Travis <travis@sgi.com>
cc: Jason Wessel <jason.wessel@windriver.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cong Wang <amwang@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 05/14] KDB: add more exports for supporting KDB modules
In-Reply-To: <20130312193824.025713118@gulag1.americas.sgi.com>
Message-ID: <alpine.LFD.2.02.1303122245310.22263@ionos>
References: <20130312193823.212544181@gulag1.americas.sgi.com> <20130312193824.025713118@gulag1.americas.sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Mar 2013, Mike Travis wrote:
> This patch adds some important KDB functions to be externally
> usable by loadable KDB modules.  Note that often drivers bring
> in KDB modules for debugging, and in the past KDB has not been
> limited to use by GPL only modules.  This patch restores KDB
> usefullness to non-GPL modules.

Which past? We only care about Linus git tree as THE past.

> -EXPORT_SYMBOL_GPL(kdb_register);
> +EXPORT_SYMBOL(kdb_register);

AFAICT that function has never been an non GPL symbol in Linus
tree. Whatever the original out of tree kdb stuff used is totally
irrelevant.

Stop trying to resolve your companys or your companys customers legal
issues by false claims.

The GPL is there for a reason.

Aside of that the whole attempt to export stuff which has been not
exported before without the _GPL extension is also:

	 Nacked-by: Thomas Gleixner <tglx@linutronix.de>

Thanks,

	tglx
