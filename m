Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaGKHkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:40:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53492 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaGKHkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:40:35 -0400
Date: Fri, 11 Jul 2014 08:40:29 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
Message-ID: <20140711074029.GD5952@console-pimps.org>
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org>
 <20140618142819.GN24049@console-pimps.org>
 <20140709182651.GB15932@console-pimps.org>
 <CAE9FiQVP6d5GhFBBmX5HDo0w0oKJSizdKvepq5t6vhGNj=W9sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVP6d5GhFBBmX5HDo0w0oKJSizdKvepq5t6vhGNj=W9sg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul, at 11:00:06AM, Yinghai Lu wrote:
> 
> Oh, no.
> 
> so efi could allocate buffer above 4g but can not access it?

I'm not exactly sure what's wrong with the buffer - whether it's a case
of not being able to access it properly or somehing buggy in the EFI
code for reading files. No fault occurs when reading into it, it just
doesn't contain the correct data.

Either way, I'm going to leave your patch as-is and just ensure I fix
this before the merge window. I think it's a good idea to have whatever
workaround we come up with documented via an entirely separate patch.

-- 
Matt Fleming, Intel Open Source Technology Center
