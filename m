Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaFYTVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:21:44 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37258 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaFYTVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:21:43 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: disable console blanking by default
Date: Wed, 25 Jun 2014 21:21:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.16.0-rc2; KDE/4.13.2; x86_64; ; )
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tomasz Torcz <tomek@pipebreaker.pl>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
References: <20140618092730.GD22226@mother.pipebreaker.pl> <20140625133930.223cccb5@alan.etchedpixels.co.uk>
In-Reply-To: <20140625133930.223cccb5@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201406252121.38263.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 of June 2014, One Thousand Gnomes wrote:
> On Wed, 18 Jun 2014 11:27:31 +0200
> 
> Tomasz Torcz <tomek@pipebreaker.pl> wrote:
> > >From ea7cf47e3230eda63aa6c46092719437f9bbae8e Mon Sep 17 00:00:00 2001
> > 
> > From: Tomasz Torcz <tomek@pipebreaker.pl>
> > Date: Wed, 18 Jun 2014 11:18:06 +0200
> > Subject: [PATCH] vt: disable console blanking by default
> > 
> >   Remove default 10 minute blank interval. Instead: never blank by
> >   default.
> >   "Screensaving" is no longer useful.  Today it only provides
> >   obstacle when interacting with text console, especially through
> >   remote lights-out management solutions.
> 
> Screensaving is extremely useful as is power management, and power prices
> are going up not down. We don't customise the upstream kernel just
> because J Random User happens to want his defaults.
> 
> There are a couple of things you can sensibly do
> 
> 1. Just turn it off in software. It's run time configurable via setterm
> 
> 2. If you have a reliable way of detecting the presence of a remote
> console device and that device supports reporting when a connection is
> made/broken you could submit a patch to make it unblank on connect.

3. unblank & disable blanking on any oops? (probably problematic)

Anyway I dislike blanking here, too.

> Alan


-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
