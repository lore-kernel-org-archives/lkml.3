Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab3HTV1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:27:18 -0400
Received: from mout.gmx.net ([212.227.17.22]:54819 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab3HTV1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:27:17 -0400
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Remove braces to fix build for clang. No functional change otherwise.
Date: Tue, 20 Aug 2013 23:26:01 +0200
Message-ID: <1729833.NqCHnaFaae@aragorn.auenland.lan>
User-Agent: KMail/4.10.5 (Linux/3.7.10-1.16-default; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130820212433.GA9856@kroah.com>
References: <1377031926-18436-1-git-send-email-dl9pf@gmx.de> <20130820212433.GA9856@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:bNGPDARbyKe/oCg4ogtYXMRv4doQQVe1LpGaVL29a9JIw7iUq8H
 XCOdvy+7+1slzLonhyckfdWlfXLxi4GnN+mszkLyUVtae+S59/WAm6MdzEXDODP6X4ZO+O6
 15qeV6rjy7Oa5hyuftDSWy/3lOYAiWSZkWc7q44y5cET2glBfK2tsTY6P8nGQCZpVyZ/rkJ
 ljnNbmrmmh0OgC0/Z3CCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 August 2013 14:24:33 Greg Kroah-Hartman wrote:
> On Tue, Aug 20, 2013 at 10:52:06PM +0200, dl9pf@gmx.de wrote:
> > From: Jan-Simon Möller <dl9pf@gmx.de>
> > 
> > Author:  PaX Team <pageexec at freemail.hu>
> > ML-Post:
> > http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/1427
> > 07.html URL:     http://llvm.linuxfoundation.org
> > 
> > Merge:   Jan-Simon Möller <dl9pf at gmx.de>
> 
> What am I supposed to do with these?
> 
> > Description:
> >   Clang chokes on the notation "inl (%dx)" but works for "inl %dx"; GNU as
> >   accepts both forms.
> No need for "description", that's implied by the body of the changelog
> text.  Also, you can wrap your lines :)
> 
> I'll clean this all up by hand, but please do this next time so I don't
> have to.

Roger that - ignore it in the other 2 I just sent out.  c'n'p from the 
existing commit msg. 
Do you want all 3 w/o then ?

JS

