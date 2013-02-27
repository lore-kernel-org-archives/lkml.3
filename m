Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355Ab3B0Qxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:53:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54899 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab3B0Qx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:53:28 -0500
Date: Wed, 27 Feb 2013 17:53:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Joe Perches <joe@perches.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        Nicolas Pitre <nico@fluxnic.net>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, David Sterba <dsterba@suse.cz>,
        Richard Cochran <richardcochran@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com
Subject: Re: [RFC PATCH v2 0/4] Add support for LZ4-compressed kernel
Message-ID: <20130227165320.GB2638@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Joe Perches <joe@perches.com>, Peter Korsgaard <jacmet@sunsite.dk>,
	Nicolas Pitre <nico@fluxnic.net>,
	"Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
	Kyungsik Lee <kyungsik.lee@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Michal Marek <mmarek@suse.cz>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	x86@kernel.org, celinux-dev@lists.celinuxforum.org,
	Nitin Gupta <nitingupta910@gmail.com>,
	Richard Purdie <rpurdie@openedhand.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Joe Millenbach <jmillenbach@gmail.com>,
	David Sterba <dsterba@suse.cz>,
	Richard Cochran <richardcochran@gmail.com>,
	Albin Tonnerre <albin.tonnerre@free-electrons.com>,
	Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com,
	chan.jeong@lge.com, raphael.andy.lee@gmail.com
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
 <512D1C12.4080109@oberhumer.com>
 <alpine.LFD.2.03.1302261557220.1254@syhkavp.arg>
 <87fw0i7n6d.fsf@dell.be.48ers.dk>
 <20130226221027.GW17833@n2100.arm.linux.org.uk>
 <1361929234.1924.8.camel@joe-AO722>
 <20130227095609.GY17833@n2100.arm.linux.org.uk>
 <1361980152.2035.13.camel@joe-AO722>
 <20130227163118.GB17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130227163118.GB17833@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 04:31:18PM +0000, Russell King - ARM Linux wrote:
> I'm not saying that the LZO code should not be updated. I'm saying
> that the kernel boot time decompressor is not a play ground for an
> ever increasing number of "my favourite compression method" crap.
> We don't need four, five or even six compression methods there. We
> just need three - a "fast but large", "small but slow" and "all round
> popular medium".

Hell yeah!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
