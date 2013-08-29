Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3H2OOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:14:45 -0400
Received: from mout.gmx.net ([212.227.17.21]:53333 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab3H2OOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:14:43 -0400
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: PaX Team <pageexec@freemail.hu>, Behan Webster <behanw@converseincode.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Remove braces in drivers/scsi/in2000.h to fix build for clang. No functional change otherwise.
Date: Thu, 29 Aug 2013 16:13:05 +0200
Message-ID: <4228569.UTsusHNv0I@aragorn.auenland.lan>
User-Agent: KMail/4.11 (Linux/3.7.10-1.16-default; KDE/4.11.0; x86_64; ; )
In-Reply-To: <4059776.Z90q7kXsSC@aragorn.auenland.lan>
References: <1377033546-19475-1-git-send-email-dl9pf@gmx.de> <2050670.KsM0dPm3or@aragorn.auenland.lan> <4059776.Z90q7kXsSC@aragorn.auenland.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:VEs414Q/HD5B3jCbhA+01awkASybm9e6viswl6sKXxNuv6jJna2
 pHrq8yUb+8P3mhJQA2vC+MGUe2p/99/hcT1qmmiKPXP+PFVBQPI54qR0+BSFTAwJHvBKftZ
 Xf//7GWALa0Y+eQk1xA3zRi1nep+kGXQ6uzm5YHR6ffJ9XcR3wQ2MlYqRJOgWCjKsOsegZa
 BeuE1PlZCRXBcfzgvKvIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.
@Christoph  do you take care of removing then ? 

Or can we merge this patch as-is now.

Best,
JS


On Wednesday 21 August 2013 15:11:33 Jan-Simon Möller wrote:
> On Wednesday 21 August 2013 09:26:14 Jan-Simon Möller wrote:
> > > > Description:
> > > >   Clang chokes on the notation "insw (%%dx)" but works for "insw %%dx"
> > > >   (outsw likewise); GNU as accepts both forms.
> > > > 
> > > > Signed-off-by: Jan-Simon M??ller <dl9pf@gmx.de>
> > > 
> > > I think the right fix is to simply kill the FAST_READ_IO/FAST_WRITE_IO
> > > defines and their associated inline assembly entirely.
> > 
> > No objection ;) .
> 
> @Christoph Hellwig:
> Do you take care of removing it then ?
> 
> BR,
> JS

