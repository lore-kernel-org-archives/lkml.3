Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab3HUNMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:12:53 -0400
Received: from mout.gmx.net ([212.227.15.15]:58138 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab3HUNMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:12:52 -0400
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: PaX Team <pageexec@freemail.hu>, Behan Webster <behanw@converseincode.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Remove braces in drivers/scsi/in2000.h to fix build for clang. No functional change otherwise.
Date: Wed, 21 Aug 2013 15:11:33 +0200
Message-ID: <4059776.Z90q7kXsSC@aragorn.auenland.lan>
User-Agent: KMail/4.11 (Linux/3.7.10-1.16-default; KDE/4.11.0; x86_64; ; )
In-Reply-To: <2050670.KsM0dPm3or@aragorn.auenland.lan>
References: <1377033546-19475-1-git-send-email-dl9pf@gmx.de> <20130821065018.GB9043@infradead.org> <2050670.KsM0dPm3or@aragorn.auenland.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:b5AZX/pittW9YzsEVpB4v8REOCG91INFmfMaC+IGcXcp3uQ+PJL
 3ksh6HB6avca972tDOa7sGhsyf0Y7xw4wntBPVqXSshj4Yz21i7oSx9ZCytvBoiVjpxlJea
 D/RHv+Pca4ECKSfmPSM3NZUbb0xM2KDsek8q2+IeDShWOqz59hwWJiltVIiRgSNMwYkhSOa
 xa9nbxWFC+EY+dg4Nz9kA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 August 2013 09:26:14 Jan-Simon Möller wrote:
> > > Description:
> > >   Clang chokes on the notation "insw (%%dx)" but works for "insw %%dx"
> > >   (outsw likewise); GNU as accepts both forms.
> > > 
> > > Signed-off-by: Jan-Simon M??ller <dl9pf@gmx.de>
> > 
> > I think the right fix is to simply kill the FAST_READ_IO/FAST_WRITE_IO
> > defines and their associated inline assembly entirely.
> 
> No objection ;) .
@Christoph Hellwig:
Do you take care of removing it then ?

BR,
JS
