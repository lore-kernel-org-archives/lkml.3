Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3CXTt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 15:49:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36335 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab3CXTt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 15:49:27 -0400
Date: Sun, 24 Mar 2013 20:49:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lijo Antony <lijo.kernel@gmail.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@linux.ie>
Subject: Re: [Nouveau] nouveau lockdep splat
Message-ID: <20130324194924.GC4866@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Lijo Antony <lijo.kernel@gmail.com>,
	Peter Hurley <peter@hurleysoftware.com>,
	Ben Skeggs <bskeggs@redhat.com>, Lucas Stach <dev@lynxeye.de>,
	nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>
References: <20130304211608.GD22274@pd.tnic>
 <1362501052.1933.2.camel@antimon>
 <20130319202432.GC4570@pd.tnic>
 <1363725620.3413.29.camel@thor.lan>
 <5149589D.6090403@gmail.com>
 <5149D467.7030908@gmail.com>
 <20130320152948.GD15471@pd.tnic>
 <514F3F57.5080407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <514F3F57.5080407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 10:00:55PM +0400, Lijo Antony wrote:
> Looks like this has been fixed in -rc4.

Yep, it seems so here too.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
