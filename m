Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3ALRQw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:16:52 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50318 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab3ALRQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:16:51 -0500
Date: Sat, 12 Jan 2013 09:16:51 -0800
From: Olof Johansson <olof@lixom.net>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH 0/4] arm: vt8500: Add support for Wondermedia
 WM8750/WM8850
Message-ID: <20130112171651.GC24073@quad.lixom.net>
References: <1357935162-7672-1-git-send-email-linux@prisktech.co.nz>
 <20130111215659.GA16521@quad.lixom.net>
 <1357960044.8515.0.camel@gitbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357960044.8515.0.camel@gitbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 04:07:24PM +1300, Tony Prisk wrote:
> > I suggest that you split off the last three (and rebase them to be
> > independent), and apply them to a multiplatform branch for vt8500. Then the
> > last one is a soc branch that goes on top of the multiplatform branch (i.e. you
> > build it on top of multiplatform). That way we can pull in the multiplatform
> > changes together with those for other platforms, and then take the wm8{7,8}50
> > branch goes in with the other new-soc support from other platforms.
> > 
> > Does that make sense? I'll be happy to provide more explanation if it doesn't.
> > 
> > -Olof
> 
> I think I understand - pull requests to follow.

Looks good, thanks for fixing it up. Next time feel free to change to
fresh subjects on the pull requests. :)

I don't see your PGP key uploaded to the public key servers, and you
likely don't have it signed by anyone else. If you have a chance, please
try to get it signed by a few people. Ideal time to do that is if you're
going to any conferences, but there are also local people around the
world that can meet up sometimes.


-Olof
