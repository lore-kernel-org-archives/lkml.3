Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab3EMCEE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:04:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41764 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3EMCEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:04:02 -0400
Date: Mon, 13 May 2013 03:04:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: linux-3.10-rc1 procfs interface breaks vmware, eicon, fio ....
 any fix?
Message-ID: <20130513020400.GS25399@ZenIV.linux.org.uk>
References: <CAAJw_Zv4Cy-fSg24F=7poRNs2oGA=7nuZQtQOyf_-dsStzNpgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAJw_Zv4Cy-fSg24F=7poRNs2oGA=7nuZQtQOyf_-dsStzNpgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 08:19:46AM +0800, Jeff Chua wrote:
> Anyone on lkml working on patches for vmware to make it run on
> Linux-3.10-rc1? The recent change in procfs interface breaks vmware,
> diva/eicon and fio modules.
> 
> Every modules is now broken and needs to be reworked. Is there a more
> subtle way to handle this like give more time to allow developers to
> handle the move rather than killing off the "tranditional" procfs
> access

I might feel bad about those, if not for one thing - their authors
had explicitly chosen to keep them out of tree and did not bother
to watch what was going on in linux-next - these changes had been
there for quite a while.  And now you have a chutzpah to come and
complain about that?  Better yet, we are expected to be working on
fixing those?  Really?  It's not a rethorical question - I seriously
want to know whether I'd misparsed what you meant to say.
