Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3CBFXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 00:23:38 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54430 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3CBFXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 00:23:38 -0500
Date: Sat, 2 Mar 2013 05:23:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jslaby@suse.cz
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
Message-ID: <20130302052330.GV4503@ZenIV.linux.org.uk>
References: <20130301.164711.326215889038834651.davem@davemloft.net>
 <20130301215609.GA3261@kroah.com>
 <20130301.171008.1027312383466468118.davem@davemloft.net>
 <20130302154935.b5695346222e75562c0327e0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130302154935.b5695346222e75562c0327e0@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 03:49:35PM +1100, Stephen Rothwell wrote:
> On Fri, 01 Mar 2013 17:10:08 -0500 (EST) David Miller <davem@davemloft.net> wrote:

> > Ok, next I'm hitting some regression in Al Viro's signal changes when userland
> > starts up. :-)
> 
> If only we had some way of testing this stuff before it gets into Linus'
> tree ... ;-)

Dave, my deep apologies.  I only now realized that you hadn't been on Cc of
the discussion of that crap; see signal.git#for-linus (commit aee41fe) for
fix...  I thought I'd Cc'd you back then (about a week ago) ;-/
