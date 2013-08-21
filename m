Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab3HUH1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:27:31 -0400
Received: from mout.gmx.net ([212.227.17.20]:56101 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab3HUH13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:27:29 -0400
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: PaX Team <pageexec@freemail.hu>, Behan Webster <behanw@converseincode.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Remove braces in drivers/scsi/in2000.h to fix build for clang. No functional change otherwise.
Date: Wed, 21 Aug 2013 09:26:14 +0200
Message-ID: <2050670.KsM0dPm3or@aragorn.auenland.lan>
User-Agent: KMail/4.10.5 (Linux/3.7.10-1.16-default; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130821065018.GB9043@infradead.org>
References: <1377033546-19475-1-git-send-email-dl9pf@gmx.de> <20130821065018.GB9043@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:tZZqj6dEqXmJKD5ThR0+gh42zBoQW9Q7BnNm7uSWgSYHpT0shtQ
 MEsJHs4NIS93ghxxllgQGdBkcoh9cRdB2Zmb61ZuGRUV3zGFrJb3dKTY8zKUxb274sRhhea
 CstQaJ4mvbwB3L6SV5NT3A2Y3ijbMAeYQyjAy7+DJYdAwOMPaFH8JtnxpV8gq84Ui1isdsx
 eoOjNemwV/qWS6U9MELaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Description:
> >   Clang chokes on the notation "insw (%%dx)" but works for "insw %%dx"
> >   (outsw likewise); GNU as accepts both forms.
> > 
> > Signed-off-by: Jan-Simon M??ller <dl9pf@gmx.de>
> 
> I think the right fix is to simply kill the FAST_READ_IO/FAST_WRITE_IO
> defines and their associated inline assembly entirely.

No objection ;) .
