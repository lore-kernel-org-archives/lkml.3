Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3A0LDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 06:03:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38690 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756540Ab3A0LD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 06:03:29 -0500
Date: Sun, 27 Jan 2013 12:06:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: X86 ML <x86@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>, Dmitry Torokhov <dtor@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH -v3 2/2] x86: Make Linux guest support optional
Message-ID: <20130127110616.GD8894@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	X86 ML <x86@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
	olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
	Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
	Borislav Petkov <bp@suse.de>, Dmitry Torokhov <dtor@vmware.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>
References: <20130125190340.GC4973@pd.tnic>
 <1359241851-7594-2-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359241851-7594-2-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 12:10:51AM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Put all config options needed to run Linux as a guest behind a
> CONFIG_HYPERVISOR_GUEST menu so that they don't get built-in by default
> but be selectable by the user. Also, make all units which depend on
> x86_hyper, depend on this new symbol so that compilation doesn't fail
> when CONFIG_HYPERVISOR_GUEST is disabled but those units assume its
> presence.
> 
> While at it, adjust text to changes, remove redundant select.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Dmitry Torokhov <dtor@vmware.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: devel@linuxdriverproject.org

Actually, on a second thought, please hold off from applying this one
just yet - I think I can squeeze in more cleanups, while at it. Running
build-tests now...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
