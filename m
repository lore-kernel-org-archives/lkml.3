Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab3CFLQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:16:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34629 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab3CFLQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:16:07 -0500
Date: Wed, 6 Mar 2013 12:16:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Florian Fainelli <florian@openwrt.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Russell King <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org,
        Nicolas Pitre <nico@fluxnic.net>, David Sterba <dsterba@suse.cz>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [PATCH v3 -next 5/5] Kconfig: Make x86 and arm kernels default
 to the LZ4-compressed
Message-ID: <20130306111600.GA30724@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Florian Fainelli <florian@openwrt.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kyungsik Lee <kyungsik.lee@lge.com>,
	Russell King <linux@arm.linux.org.uk>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, x86@kernel.org,
	celinux-dev@lists.celinuxforum.org,
	Nicolas Pitre <nico@fluxnic.net>, David Sterba <dsterba@suse.cz>,
	Nitin Gupta <nitingupta910@gmail.com>,
	Joe Millenbach <jmillenbach@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
	hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
 <1362484056-9778-6-git-send-email-kyungsik.lee@lge.com>
 <5135DF44.2040806@openwrt.org>
 <20130305150845.0d19a2875d39dac5d03b4b62@linux-foundation.org>
 <51371320.6000002@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51371320.6000002@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 10:57:52AM +0100, Florian Fainelli wrote:
> If we want to have more coverage, how about importing the lz4demo
> utility source code to tools/lz4/

That looks like on overkill to me, besides I don't think that's the
purpose of tools/. Maybe everyone who wants to test this, should install
the tool and go wild without disturbing the default.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
