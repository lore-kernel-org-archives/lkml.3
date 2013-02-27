Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3B0Ulc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 15:41:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55002 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab3B0Ulb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:41:31 -0500
Date: Wed, 27 Feb 2013 21:41:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "gnehzuil.liu" <gnehzuil.liu@gmail.com>,
        Zheng Liu <wenqing.lz@taobao.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL URGENT] ext4 regression fix for 3.9
Message-ID: <20130227204123.GM5530@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
 <20130227174553.GA224@x4>
 <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
 <20130227184912.GA19624@thunk.org>
 <20130227185625.GA224@x4>
 <20130227191923.GA1121@redhat.com>
 <20130227192907.GB14253@thunk.org>
 <20130227201217.GD14253@thunk.org>
 <20130227201503.GF14253@thunk.org>
 <CA+55aFx+mHr080Wzfo8s8cb4qAO74x0r8iDFE90CziybFSTgQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFx+mHr080Wzfo8s8cb4qAO74x0r8iDFE90CziybFSTgQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 12:23:18PM -0800, Linus Torvalds wrote:
> On Wed, Feb 27, 2013 at 12:15 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Wed, Feb 27, 2013 at 03:12:17PM -0500, Linus Torvalds wrote:
> >> The following changes since commit 304e220f0879198b1f5309ad6f0be862b4009491:
> >
> > Obviously, this wasn't from Linus.  I screwed up on sending the pull
> > request.  Sigh...
> 
> That looked really odd in my inbox for a while ;)
> 
>           Linus "the *real* one" Torvalds

He doesn't trust anyone - he sends pull requests to himself!

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
