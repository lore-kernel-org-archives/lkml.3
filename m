Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab3AYTAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 14:00:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37269 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab3AYTAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 14:00:51 -0500
Date: Fri, 25 Jan 2013 20:03:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Dmitry Torokhov <dtor@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH -v2 2/2] x86: Make Linux guest support optional
Message-ID: <20130125190340.GC4973@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	X86 ML <x86@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
	olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
	Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
	Dmitry Torokhov <dtor@vmware.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>
References: <20130125100655.GC23404@pd.tnic>
 <1359136777-4512-2-git-send-email-bp@alien8.de>
 <20130125181251.GA5563@core.coreip.homeip.net>
 <20130125183213.GB1380@pd.tnic>
 <20130125184231.GB5563@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130125184231.GB5563@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:42:32AM -0800, Dmitry Torokhov wrote:
> No, not really as EXPORT_SYMBOL_GPL() in no way implies that the code
> using it lives in the mainline.

I didn't say that - I said "any code (proprietary included) can link to
those symbols" meaning that I cannot possibly convert proprietary code
to which I don't have access to, vs GPL code which is out there.

> Also, EXPORT_SYMBOL() does not imply that it forms an ABI and can't be
> changed ever.

And yet, I don't want to be on the receiving end of the complaints when
those do change. But that's beside the point.

So I think we're on the same page: I'll make everything using x86_hyper*
depend on CONFIG_HYPERVISOR_GUEST and all are happy.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
