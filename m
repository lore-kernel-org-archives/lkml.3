Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab3A0K1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 05:27:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53224 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362Ab3A0K1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 05:27:16 -0500
Date: Sun, 27 Jan 2013 11:30:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dmitry Torokhov <dtor@vmware.com>, Ingo Molnar <mingo@kernel.org>,
        X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH -v2 2/2] x86: Make Linux guest support optional
Message-ID: <20130127103001.GA8894@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Dmitry Torokhov <dtor@vmware.com>,
	Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
	olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
	Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>
References: <20130125100655.GC23404@pd.tnic>
 <1359136777-4512-2-git-send-email-bp@alien8.de>
 <20130125180730.GA29810@dtor-ws.eng.vmware.com>
 <20130125182335.GA1380@pd.tnic>
 <20130125182925.GB29810@dtor-ws.eng.vmware.com>
 <20130125183507.GA4973@pd.tnic>
 <20130125184356.GB4973@pd.tnic>
 <51048250.6060108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51048250.6060108@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 05:26:40PM -0800, H. Peter Anvin wrote:
> Out-of-tree code is responsible for keeping up, not the other way around.

Ok, this actually a "doh, Boris, of course". If code wants to work with
linux, it should be upstream in the first place. Otherwise, it has to
keep up. Cool.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
