Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3GFTMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 15:12:42 -0400
Received: from shutemov.name ([204.155.152.216]:35909 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3GFTMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 15:12:38 -0400
Date: Sat, 6 Jul 2013 22:12:37 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 2/2] perf: squelch warnings from perl.h to compile-pass
Message-ID: <20130706191237.GA2468@shutemov.name>
References: <1372945246-21605-1-git-send-email-artagnon@gmail.com>
 <1372945246-21605-3-git-send-email-artagnon@gmail.com>
 <878v1lzqe3.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v1lzqe3.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 11:34:12AM +0900, Namhyung Kim wrote:
> Hi Ramkumar,
> 
> On Thu,  4 Jul 2013 19:10:46 +0530, Ramkumar Ramachandra wrote:
> > Currently, a simple
> >
> >   $ make
> >
> > errors out because we compile with -Werror by default, turning all
> > warnings into errors.  Although no warnings are emitted by our code
> > itself, two kinds of warnings are emitted by perl.h (perl 5.18.0):
> >
> >   -Wundef and -Wswitch-default
> 
> IIRC there's a floating patch for this, but I cannot find it now.

This one: https://lkml.org/lkml/2013/6/24/66 ?

-- 
 Kirill A. Shutemov
