Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945892Ab3AYKEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:04:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54512 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab3AYKEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:04:06 -0500
Date: Fri, 25 Jan 2013 11:06:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 1/2] x86, Kconfig: Move PARAVIRT_DEBUG into the paravirt
 menu
Message-ID: <20130125100655.GC23404@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	X86 ML <x86@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
	olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
	Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
	Borislav Petkov <bp@suse.de>
References: <20130124173555.GJ13463@pd.tnic>
 <1359049194-17505-1-git-send-email-bp@alien8.de>
 <20130125082126.GD25314@gmail.com>
 <20130125085146.GA23404@pd.tnic>
 <20130125092032.GC31478@gmail.com>
 <20130125092915.GB23404@pd.tnic>
 <20130125093241.GA19717@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130125093241.GA19717@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:32:41AM +0100, Ingo Molnar wrote:
> That's ok. I'll apply them to tip:x86/cpu and then resolve the
> conflicts against tip:master.

Ok, I redid them against tip:x86/cpu and am running build tests. Will
send out later after a sufficient number of randconfigs passes.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
