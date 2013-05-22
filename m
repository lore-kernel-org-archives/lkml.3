Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab3EVR4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:56:35 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:50839 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab3EVR4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:56:33 -0400
Date: Wed, 22 May 2013 13:56:17 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Cc: "luke.leighton" <luke.leighton@gmail.com>,
        Ian Stirling <gplvio@mauve.plus.com>, legal@lists.gpl-violations.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Would like to form a pool of Linux copyright holders for faster
 GPL enforcement against Anthrax Kernels
Message-ID: <20130522175617.GA20848@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>,
	"luke.leighton" <luke.leighton@gmail.com>,
	Ian Stirling <gplvio@mauve.plus.com>,
	legal@lists.gpl-violations.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <51972CAF.3060802@gmail.com>
 <CAPweEDxgT+ZygfPZDd8YePe7RurTU7o_UtiBqjUvCMimChpTug@mail.gmail.com>
 <ce644e6e12d68aaabed7403b5f21c124@imap.plus.net>
 <CAPweEDztcCOgKQmMSK3R6TMJoOo5m4b5KFg1nVySexqdVZu_DQ@mail.gmail.com>
 <20130522181329.234f43f0@m4a785t-m.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522181329.234f43f0@m4a785t-m.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 06:13:29PM +0200, Denis 'GNUtoo' Carikli wrote:
> On Sun, 19 May 2013 11:57:15 +0100 "luke.leighton" <luke.leighton@gmail.com> wrote:
> >  so.  could someone please inform me what the procedure is: is it as
> > simple as submitting a patch?
> I think so(however I'm not a kernel maintainer),
> I found that(however the patch is really old):
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=798b6b19d7a4b6e1ea5340ec8b3b92811e05b81b
> So the idea would be to send a patch or series of patches to relicense
> your code under the GPLv2+(GPLv2 or later).

Only if you own the copyright on all of the lines of code of the file
in question.

						- Ted
