Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab3BEGOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 01:14:25 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:55063 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3BEGOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 01:14:24 -0500
Date: Tue, 5 Feb 2013 08:14:13 +0200 (EET)
From: Tero Roponen <tero.roponen@gmail.com>
X-X-Sender: terrop@terrop.lan
To: Miklos Szeredi <miklos@szeredi.hu>
cc: Tero Roponen <tero.roponen@gmail.com>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: User-triggerable WARNING with fuse
In-Reply-To: <CAJfpegufyY_ZcvKgMVZsLA81ODJwKmStcxDTpObXHfBDRzLKog@mail.gmail.com>
Message-ID: <alpine.LFD.2.03.1302050812140.1227@gmail.com>
References: <alpine.LFD.2.03.1302011328410.6240@gmail.com> <CAJfpegufyY_ZcvKgMVZsLA81ODJwKmStcxDTpObXHfBDRzLKog@mail.gmail.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 4 Feb 2013, Miklos Szeredi wrote:

> On Fri, Feb 1, 2013 at 12:39 PM, Tero Roponen <tero.roponen@gmail.com> wrote:
> >
> > Using the attached program I can trigger the following WARNING
> > reliably as a normal user. This happens at least both in 3.8-rc6
> > and 3.7.5.
> >
> > The kernel is tainted by proprietary NVIDIA module, but I don't
> > thinks it matters in this case.
> >
> 
> Thanks, the attached patch should fix it.

Yes, that fixed it.

-- 
Tero Roponen
