Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaBATMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 14:12:16 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:61892 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaBATMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 14:12:14 -0500
MIME-Version: 1.0
In-Reply-To: <20140131172443.2EDC06E7@viggo.jf.intel.com>
References: <20140131172443.2EDC06E7@viggo.jf.intel.com>
Date: Sat, 1 Feb 2014 11:12:13 -0800
X-Google-Sender-Auth: MTWNreYkXe4GFDu9-jo43PHI-Xc
Message-ID: <CA+55aFzs7h8YhQ3wmV=UnuQ5K9VhM_Lr_4HUrGWBn4vcyzvi8A@mail.gmail.com>
Subject: Re: [PATCH 0/3] General Kconfig reorganization
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Hansen <dave@sr71.net>, Michal Marek <mmarek@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have nothing against this series of patches, but appreciate it going
through the kconfig maintainer, since we have one.

Michal added to the participants. Dave, I don't think the patches
themselves were cc'd to Michal either, but I didn't check.

           Linus

On Fri, Jan 31, 2014 at 9:24 AM, Dave Hansen <dave@sr71.net> wrote:
> Changes from last version:
>  * Change one sentence in the existing SECCOMP description to be
>    the text that Ingo wants.
>
> This continues in a series of patches to clean up the
> configuration menus.  I believe they've become really hard to
> navigate and there are some simple things we can do to make
> things easier to find.
>
