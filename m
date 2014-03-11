Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaCKAjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:39:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbaCKAji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:39:38 -0400
Date: Mon, 10 Mar 2014 20:38:56 -0400
From: Dave Jones <davej@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>, Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove compat vdso support
Message-ID: <20140311003856.GA4203@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	X86 ML <x86@kernel.org>, Stefani Seibold <stefani@seibold.net>,
	Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
	Martin Runge <Martin.Runge@rohde-schwarz.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <775280bd6cab6345a1d340e7038d2011763bf81b.1394492341.git.luto@amacapital.net>
 <531E5531.20409@linux.intel.com>
 <CALCETrX1RBVYAKyN_GdvF8w3S=A5wZ_XaMqR_MjdLim7RMR8NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX1RBVYAKyN_GdvF8w3S=A5wZ_XaMqR_MjdLim7RMR8NQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 05:19:27PM -0700, Andy Lutomirski wrote:
 > On Mon, Mar 10, 2014 at 5:13 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
 > > On 03/10/2014 05:12 PM, Andy Lutomirski wrote:
 > >> The compat vDSO is a complicated hack that's needed to maintain
 > >> compatibility with a small range of never-released glibc versions.
 > >>
 > >> This removes it and replaces it with a much simpler hack: a config
 > >> option to disable the 32-bit vDSO by default.
 > >>
 > >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
 > >
 > > Can we verify this works correctly on the affected distributions?
 > 
 > It works correctly on Fedora 20 32-bit and 64-bit.

I went and dug through the SRPMs at https://archives.fedoraproject.org
Fedora hasn't ever shipped with COMPAT_VDSO enabled.
Before FC6 (kernel 2.6.18), the option never existed.

	Dave

