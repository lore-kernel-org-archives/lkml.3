Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaKYIeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:34:12 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:62833 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaKYIeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:34:11 -0500
MIME-Version: 1.0
In-Reply-To: <20141124131200.GA28582@phare.normalesup.org>
References: <20141124131200.GA28582@phare.normalesup.org>
Date: Tue, 25 Nov 2014 09:34:10 +0100
Message-ID: <CAFLxGvz03NSTF1jedm8wge8QKhDZcucgdJWBiWVBpfkQLU-0UA@mail.gmail.com>
Subject: Re: Using kernel filesystems as userland libraries
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Nicolas George <george@nsup.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 2:12 PM, Nicolas George <george@nsup.org> wrote:
> Hi.
>
> With the libraries present in e2fsprogs, it is possible to open a plain file
> (or any other reasonable storage) as an EXT2 filesystem and manipulate files
> inside it.
>
> Is it possible to use the implementations in the kernel to do the same thing
> with any supported normal filesystem?
>
> Obviously, it is theoretically possible, but my question is whether it has
> been done in practice. I suppose it would require writing userland
> replacement for the kernel APIs (memory management, access to block devices,
> scheduling) and either rebuilding the kernel source as userland code or
> loading the modules directly.

Regarding the interfaces, we have FUSE.
But there is no tool which can automagically convert kernel filesystem code
into FUSE userland code. It has to be done by hand.
For some filesystems we have already FUSE implementations.

-- 
Thanks,
//richard
