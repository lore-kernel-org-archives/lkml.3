Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbbANJCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:02:41 -0500
Received: from mail.dit.upm.es ([138.4.2.7]:47738 "EHLO mail.dit.upm.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbbANJCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:02:37 -0500
X-Greylist: delayed 1517 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2015 04:02:36 EST
Message-ID: <1421224623.3852.7.camel@jonsy.dit.upm.es>
Subject: Re: [Nbd] NBD Maintainer
From: Juan Antonio Martinez <jantonio@dit.upm.es>
To: Tuomas =?ISO-8859-1?Q?R=E4s=E4nen?= <tuomasjjrasanen@tjjr.fi>
Cc: paul.clements@us.sios.com, nbd-general@lists.sourceforge.net,
        andrey.krieger.utkin@gmail.com, linux-kernel@vger.kernel.org
Date: Wed, 14 Jan 2015 09:37:03 +0100
In-Reply-To: <s70vhy.ni5p0b.2zdyk6-qmf@mail.kapsi.fi>
References: <CAECXXi7Ax3t2b7x=KqUF1udNKWgQnGebVtkyLHnjhxEZ2o=M5g@mail.gmail.com>
	 <CANZNk812oKH3k+bW8Jb2fQHxOS+pF=ghHpekB4X8QtQm67X-hQ@mail.gmail.com>
	 <CAECXXi4mEV2=-w95LJCDA=zf6f8_SCRBHYkp2tTwUuAJiOjaQQ@mail.gmail.com>
	 <s70vhy.ni5p0b.2zdyk6-qmf@mail.kapsi.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El mié, 14-01-2015 a las 07:33 +0000, Tuomas Räsänen escribió:
> Hi
> 
> On Tue Jan 13 21:26:01 2015 GMT+0200, Paul Clements wrote:
> > On Tue, Jan 13, 2015 at 11:14 AM, Andrey Utkin
> > <andrey.krieger.utkin@gmail.com> wrote:
> > > Hi Paul,
> > > could you please describe
> > > - how wide is NBD usage today (any estimation is ok),

We at Universidad Politécnica de Madrid (Spain) have 7 clustered NBD
servers, 200+ nbd clients and about 3500 users ( teachers & students )

AFAIK NBD based LTSP installations are very common in educational
environments

Juan Antonio

