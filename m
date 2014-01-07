Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaAGTDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:03:18 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:48212 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaAGTDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:03:12 -0500
Message-ID: <1389121384.6687.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc: whitespace cleanup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Joe Perches <joe@perches.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>
Date: Tue, 07 Jan 2014 11:03:04 -0800
In-Reply-To: <1389115444.32137.9.camel@joe-AO722>
References: <1387897356-6140-1-git-send-email-manfred@colorfullife.com>
	 <1389114734.3095.3.camel@buesod1.americas.hpqcorp.net>
	 <1389115444.32137.9.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 09:24 -0800, Joe Perches wrote:
> On Tue, 2014-01-07 at 09:12 -0800, Davidlohr Bueso wrote:
> > On Tue, 2013-12-24 at 16:02 +0100, Manfred Spraul wrote:
> > > The ipc code does not adhere the typical linux coding style.
> > > This patch fixes lots of simple whitespace errors.
> > 
> > While it's no big deal, the title of the patch doesn't really reflect
> > the actual changes as it deals with much more than just whitespace
> > cleanups. How about something like "ipc: checkpatch fixes"?
> 
> Isn't a patch where "git diff -w" is empty
> whitespace only cleanups?
> 
> $ git diff --help
> []
>        -w, --ignore-all-space
>            Ignore whitespace when comparing lines. This ignores differences
>            even if one line has whitespace where the other line has none.
> 

Ok, sorry about the noise then, I just didn't consider foo () >> foo() a
whitespace cleanup.


