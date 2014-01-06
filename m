Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbaAFVeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:34:01 -0500
Received: from imap.thunk.org ([74.207.234.97]:46383 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312AbaAFVd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:33:57 -0500
Date: Mon, 6 Jan 2014 16:33:49 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: #pragma once?
Message-ID: <20140106213349.GF28490@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Josh Triplett <josh@joshtriplett.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
	Rashika Kheria <rashika.kheria@gmail.com>
References: <20140106204706.GA16924@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106204706.GA16924@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 12:47:07PM -0800, Josh Triplett wrote:
> Does anyone have any objection to the use of "#pragma once" instead of
> the usual #ifndef-#define-...-#endif include guard?  GCC, LLVM/clang,
> and the latest Sparse all support either method just fine.  (I added
> support to Sparse myself.)  Both have equivalent performance.  "#pragma
> once" is simpler, and avoids the possibility of a typo in the defined
> guard symbol.

Does anybody know whether other static code analysis tools such as
Coverity can handle #pragma once?

						- Ted
