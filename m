Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3AYSM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:12:58 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63025 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3AYSM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:12:56 -0500
Date: Fri, 25 Jan 2013 10:12:51 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>, Dmitry Torokhov <dtor@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH -v2 2/2] x86: Make Linux guest support optional
Message-ID: <20130125181251.GA5563@core.coreip.homeip.net>
References: <20130125100655.GC23404@pd.tnic>
 <1359136777-4512-2-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359136777-4512-2-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Fri, Jan 25, 2013 at 06:59:37PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Put all config options needed to run Linux as a guest behind a
> CONFIG_HYPERVISOR_GUEST menu so that they don't get built-in by
> default but selected by the user. Also, move x86_hyper into an
> unconditionally-built compilation unit because it is exported with the
> non-GPL flavour and we can't know whatever uses it on the outside.

I am confused by this statement... How can EXPORT_SYMBOL() vs
EXPORT_SYMBOL_GPL() help you determining if it is used out of tree or
not?

Thanks.

-- 
Dmitry
