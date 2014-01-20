Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaATNeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:34:36 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57656 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaATNee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:34:34 -0500
Date: Mon, 20 Jan 2014 13:34:24 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Pavel Shilovsky <piastry@etersoft.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux NFS Mailing list <linux-nfs@vger.kernel.org>,
        wine-devel@winehq.org
Subject: Re: [PATCH v7 1/7] VFS: Introduce new O_DENY* open flags
Message-ID: <20140120133424.09328108@alan.etchedpixels.co.uk>
In-Reply-To: <CAKywueT=JsTkNC+w-vrN0ftam7F8Eqb8DXJ0w2G4q9vnt0hVNQ@mail.gmail.com>
References: <1389953232-9428-1-git-send-email-piastry@etersoft.ru>
	<1389953232-9428-2-git-send-email-piastry@etersoft.ru>
	<20140117181847.6c1f3831@alan.etchedpixels.co.uk>
	<CAKywueT=JsTkNC+w-vrN0ftam7F8Eqb8DXJ0w2G4q9vnt0hVNQ@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > (and why not just use EPERM, it has the meaning you want already) 
> We need to determine if we have a share reservation error to map it
> accurately in file servers and wine.

Ok

> > Shouldn't this also check for CAP_SYS_DAC or some similar permission so
> > that root can override such a mess (eg to fix full disks in an
> > emergency) ?
> 
> May be it's better to let root an ability to remount the system
> without sharelock mount option and then fix an emergency?

Doesn't that involve breaking the service for all users of the system
relying upon those locks, while root being allowed to ignore the locks
does not ?

Alan
