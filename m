Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbbAIXgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:36:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33294 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbbAIXgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:36:51 -0500
Date: Fri, 9 Jan 2015 23:36:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rich Felker <dalias@aerifal.cx>
Cc: David Drysdale <drysdale@google.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Message-ID: <20150109233644.GR22149@ZenIV.linux.org.uk>
References: <20150109205626.GK22149@ZenIV.linux.org.uk>
 <20150109205926.GT4574@brightrain.aerifal.cx>
 <20150109210941.GL22149@ZenIV.linux.org.uk>
 <20150109212852.GU4574@brightrain.aerifal.cx>
 <20150109215042.GM22149@ZenIV.linux.org.uk>
 <20150109221728.GW4574@brightrain.aerifal.cx>
 <20150109223300.GO22149@ZenIV.linux.org.uk>
 <20150109224252.GY4574@brightrain.aerifal.cx>
 <20150109225743.GP22149@ZenIV.linux.org.uk>
 <20150109231248.GZ4574@brightrain.aerifal.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109231248.GZ4574@brightrain.aerifal.cx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 06:12:48PM -0500, Rich Felker wrote:

> I'm not sure where you're disagreeing with me. open of procfs symlinks
> does not resolve the symlink and open the resulting pathname. They are
> "magic symlinks" which are bound to the inode of the open file. I
> don't see why this action, which is already special for magic
> symlinks, can't check a flag on the magic symlink and possibly close
> the corresponding file descriptor as part of its action.

_What_ action?  ->follow_link()?  As in "the same thing that e.g.
stat(2) would trigger"?
