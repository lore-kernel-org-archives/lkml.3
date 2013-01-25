Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab3AYScU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:32:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39106 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817Ab3AYScS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:32:18 -0500
Date: Fri, 25 Jan 2013 19:35:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH -v2 2/2] x86: Make Linux guest support optional
Message-ID: <20130125183507.GA4973@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dmitry Torokhov <dtor@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
	olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
	Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
	Borislav Petkov <bp@suse.de>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>
References: <20130125100655.GC23404@pd.tnic>
 <1359136777-4512-2-git-send-email-bp@alien8.de>
 <20130125180730.GA29810@dtor-ws.eng.vmware.com>
 <20130125182335.GA1380@pd.tnic>
 <20130125182925.GB29810@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130125182925.GB29810@dtor-ws.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:29:25AM -0800, Dmitry Torokhov wrote:
> Can't we make the balloon driver depend on CONFIG_HYPERVISOR_GUEST?

We certainly can do that, AFAICT.

> We do not _need_ more and have no plans to introduce new ones AFAIK,
> but I think that comparing an address of a structure instead of string
> comparison is much more elegant and it is safer from typos.

Ok, if you prefer. We can definitely make all .o's which depend on
x86_hyper also depend on CONFIG_HYPERVISOR_GUEST - this solves the whole
deal trivially.

I'll respin the patches.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
