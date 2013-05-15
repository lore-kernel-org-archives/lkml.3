Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3EOEey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 00:34:54 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34959 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3EOEew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 00:34:52 -0400
MIME-Version: 1.0
In-Reply-To: <1368592193.5890.10.camel@rzhang1-mobl4>
References: <CAPz6YkWr_D504UdeqXB0FXxgqOt3GYnF09ctoMaZ8P-znbVMGQ@mail.gmail.com>
	<1368591999.5890.9.camel@rzhang1-mobl4>
	<1368592193.5890.10.camel@rzhang1-mobl4>
Date: Tue, 14 May 2013 21:34:51 -0700
X-Google-Sender-Auth: 1kOjqAW1hlQXTGbaGP3dWUMScOQ
Message-ID: <CALiw-2H9k4v9_H-m-7wA4uAJTnRNce2bozKdGc=WGwZNuZ0mJw@mail.gmail.com>
Subject: Re: Fans at full speed after resume
From: Olof Johansson <olofj@chromium.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, linux-pm@vger.kernel.org,
        Sameer Nanda <snanda@chromium.org>,
        "Triplett, Josh" <josh.triplett@intel.com>, len.brown@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/14 Zhang Rui <rui.zhang@intel.com>
>
> On Wed, 2013-05-15 at 12:26 +0800, Zhang Rui wrote:
> > please
> >
> > On Tue, 2013-05-14 at 21:18 -0700, Sonny Rao wrote:
> > > Hi, I've seen a regression in kernels since 3.7 on x86 devices where
> > > the kernel turns the system fans on to max speed after resuming from
> > > ram.  Other people have noticed it as well, for example see
> > > https://bugzilla.redhat.com/show_bug.cgi?id=895276
> > >
> > please check if this is a duplicate of bug
> > https://bugzilla.kernel.org/show_bug.cgi?id=56591
> or you can try 3.10-rc1 to see if the problem still exists or not.
>

Or 3.8.12, from the looks of it (we're on 3.8.11 now, d'oh!).

-Olof
