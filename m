Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3EMD2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 23:28:34 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:50119 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab3EMD2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 23:28:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130513020400.GS25399@ZenIV.linux.org.uk>
References: <CAAJw_Zv4Cy-fSg24F=7poRNs2oGA=7nuZQtQOyf_-dsStzNpgw@mail.gmail.com>
	<20130513020400.GS25399@ZenIV.linux.org.uk>
Date: Mon, 13 May 2013 11:28:30 +0800
Message-ID: <CAAJw_ZseY94_u_w=P43VeUE2gNZ1qEe9Dpon3q3BEG=MPNp67w@mail.gmail.com>
Subject: Re: linux-3.10-rc1 procfs interface breaks vmware, eicon, fio ....
 any fix?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And now you have a chutzpah to come and
complain about that? Better yet, we are expected to be working on
fixing those?

Al,

Complaining about something that I can't fix, yep. But asking you to
fix those, nop! That's not my intent. All I'm trying to say is there's
too many out there who don't care about linux-next until the vanilla
version came out and then everyone (may be just me) complained that it
doesn't work anymore, So, would it be reasonable to allow the
old-method to still function may be via CONFIG_OLD_PROCFS but warning
that the old interface should not be used anymore. That's to allow
"me" to continue to be able to work on the latest linux-3.10.0-rc1
while waiting for someone to fix those old modules. Reasonable?

Thanks,
Jeff

On Mon, May 13, 2013 at 10:04 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, May 13, 2013 at 08:19:46AM +0800, Jeff Chua wrote:
>> Anyone on lkml working on patches for vmware to make it run on
>> Linux-3.10-rc1? The recent change in procfs interface breaks vmware,
>> diva/eicon and fio modules.
>>
>> Every modules is now broken and needs to be reworked. Is there a more
>> subtle way to handle this like give more time to allow developers to
>> handle the move rather than killing off the "tranditional" procfs
>> access
>
> I might feel bad about those, if not for one thing - their authors
> had explicitly chosen to keep them out of tree and did not bother
> to watch what was going on in linux-next - these changes had been
> there for quite a while.  And now you have a chutzpah to come and
> complain about that?  Better yet, we are expected to be working on
> fixing those?  Really?  It's not a rethorical question - I seriously
> want to know whether I'd misparsed what you meant to say.
