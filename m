Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaAFVvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:51:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbaAFVva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:51:30 -0500
Date: Mon, 6 Jan 2014 16:50:57 -0500
From: Dave Jones <davej@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: #pragma once?
Message-ID: <20140106215057.GB25059@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Josh Triplett <josh@joshtriplett.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
	Rashika Kheria <rashika.kheria@gmail.com>
References: <20140106204706.GA16924@leaf>
 <20140106213349.GF28490@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106213349.GF28490@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 04:33:49PM -0500, Theodore Ts'o wrote:
 > On Mon, Jan 06, 2014 at 12:47:07PM -0800, Josh Triplett wrote:
 > > Does anyone have any objection to the use of "#pragma once" instead of
 > > the usual #ifndef-#define-...-#endif include guard?  GCC, LLVM/clang,
 > > and the latest Sparse all support either method just fine.  (I added
 > > support to Sparse myself.)  Both have equivalent performance.  "#pragma
 > > once" is simpler, and avoids the possibility of a typo in the defined
 > > guard symbol.
 > 
 > Does anybody know whether other static code analysis tools such as
 > Coverity can handle #pragma once?

Coverity should be fine. If it does break, I'm sure they'd fix it.

	Dave

