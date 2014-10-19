Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaJSVEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 17:04:25 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:59795 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaJSVEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 17:04:24 -0400
Date: Mon, 20 Oct 2014 00:03:48 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
Message-ID: <20141019210348.GA28144@drone.musicnaut.iki.fi>
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Oct 19, 2014 at 01:05:22PM -0700, Linus Torvalds wrote:
> On Sun, Oct 19, 2014 at 9:07 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> > gcc5 changes the default standard to c11, rather than gnu89, which
> > makes kernel build unhappy.

(I guess the default will be gnu11 instead of c11.)

> Hmm. Just how unhappy does it make it? Maybe we can instead try to
> make the build happier with some minimal changes? Or is it really
> painful?

Here's one example how it fails: http://marc.info/?l=gcc&m=141349914632010&w=2

It's probably arch-independent as on SPARC I saw a similar failure
(I didn't test any others).

A.
