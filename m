Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaGBMtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:49:16 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58548 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaGBMtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:49:14 -0400
Date: Wed, 2 Jul 2014 13:47:21 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: kGraft to -next [was: 00/21 kGraft]
Message-ID: <20140702134721.00163886@alan.etchedpixels.co.uk>
In-Reply-To: <20140702123002.GA20071@mtj.dyndns.org>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
	<53B3F556.7050002@suse.cz>
	<20140702123002.GA20071@mtj.dyndns.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014 08:30:02 -0400
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Wed, Jul 02, 2014 at 02:04:38PM +0200, Jiri Slaby wrote:
> > On 06/25/2014 01:05 PM, Jiri Slaby wrote:
> ...
> > > https://git.kernel.org/cgit/linux/kernel/git/jirislaby/kgraft.git/log/?h=kgraft
> > 
> > Stephen,
> > 
> > may I ask you to add the kGraft tree to -next?
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jirislaby/kgraft.git#kgraft
> 
> Do we have consensus on the approach?  I personally really don't like
> the fact that it's adding another aspect to kthread management which
> is difficult to get right and nearly impossible to verify
> automatically.

Nor me. I don't see why it can't use the kernel freeze functionality ?

Alan
