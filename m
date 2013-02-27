Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306Ab3B0Qri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:47:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53455 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab3B0Qrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:47:36 -0500
Date: Wed, 27 Feb 2013 17:46:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Wim Van Sebroeck <wim@iguana.be>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-watchdog@vger.kernel.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [next-20130227] kernel NULL pointer dereference [ watchdog |
 perf related ? ]
Message-ID: <20130227164610.GG5530@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sedat Dilek <sedat.dilek@gmail.com>, Tejun Heo <tj@kernel.org>,
	Wim Van Sebroeck <wim@iguana.be>, Ingo Molnar <mingo@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-watchdog@vger.kernel.org, x86@kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andrew Morton <akpm@linux-foundation.org>
References: <CA+icZUUsedHPqZc5jXQ_AqAbfmTMu5WW8CJ+vnHwL69ofw7uTw@mail.gmail.com>
 <20130227122302.GA5678@pd.tnic>
 <CA+icZUVXDfOhztQtrOxyYaHutpx=iVpPGmRT0PzP7045_mjh6w@mail.gmail.com>
 <CA+icZUXJb5O7ML-xnQq8Zoa46NmaGZp2Xaqj6fJL+vudPeQTLw@mail.gmail.com>
 <20130227150733.GB22383@htj.dyndns.org>
 <CA+icZUUFCOPJ=TAE-5=suUqPy0NjA+BSToiZxX=Xm7u=30GdOA@mail.gmail.com>
 <20130227160833.GF5530@pd.tnic>
 <CA+icZUVhfYHu_EtC=itTR04OGq_yOq902_ZMb9_Jy=1pZfU_FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+icZUVhfYHu_EtC=itTR04OGq_yOq902_ZMb9_Jy=1pZfU_FA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 05:14:04PM +0100, Sedat Dilek wrote:
> I am not screaming or whining... people should reflect a bit on the
> patch workflow process? Also, I am sure a patchwork-service especially
> for -next is helpful.

Ok, now this formulation reads much nicer. So if you really think this
is needed, simply talk to sfr and see what he has to say about it. But
please do it in a nice way.

I'd say, serious suggestions on how the workflow could be improved are
always welcome.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
