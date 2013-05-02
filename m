Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3EBI53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:57:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34072 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab3EBI52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:57:28 -0400
Message-ID: <51822A75.7030101@suse.cz>
Date: Thu, 02 May 2013 10:57:25 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steve Russo <svrusso1@fieldeffect.info>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] kconfig: fix pointer conversion error when running
 make xconfig
References: <CABKNEQcR_AWnMptL=o0XtCyX78Cn5xiV78wxP_65O2kmeK1MNg@mail.gmail.com>
In-Reply-To: <CABKNEQcR_AWnMptL=o0XtCyX78Cn5xiV78wxP_65O2kmeK1MNg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.4.2013 19:38, Steve Russo wrote:
> From: Steve Russo <svrusso1@gmail.com <mailto:svrusso1@gmail.com>>
> 
> I could not compile "make xconfig" on the linux-next git, as of
> 20130430, due to a pointer type conversion in line 128/129 of list.h
> (couldn't convert from void* to struct list_head).

Thanks for the patch, but it has already been posted here:
http://lkml.org/lkml/2013/4/29/322

 This is my first
> patch; please forgive me if I haven't done something correctly.

First and foremost: No html email.


> Signed-off-by: Steve Russo <svrusso1@gmail.com <mailto:svrusso1@gmail.com>>
> ---
> ---
> /home/russosv/Dev/Kernel/generic/linux-next/20130429/scripts/kconfig/list.h.orig2013-04-30
> 13:09:34.708075512 -0400
> +++
> /home/russosv/Dev/Kernel/generic/linux-next/20130429/scripts/kconfig/list.h2013-04-30
> 13:07:30.113329353 -0400

Second: Please send patches so that they apply with -p1. The best is to
first send the patch to yourself and pipe the email to 'git am.' If that
works, then the odds are that it will work for the receiver as well.

Otherwise the content was OK.

Michal
