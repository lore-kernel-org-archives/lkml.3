Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbaAWWqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:46:09 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:64365 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaAWWqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:46:07 -0500
Date: Thu, 23 Jan 2014 14:45:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mike Waychison <mikew@google.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] firmware/google: drop 'select EFI' to avoid recursive
 dependency
In-Reply-To: <20140123134910.144a70cc0fd4c02ba0f14de4@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1401231444510.26509@chino.kir.corp.google.com>
References: <1390473588-23367-1-git-send-email-ard.biesheuvel@linaro.org> <alpine.DEB.2.02.1401231334540.7313@chino.kir.corp.google.com> <20140123134910.144a70cc0fd4c02ba0f14de4@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014, Andrew Morton wrote:

> > $ ./scripts/get_maintainer.pl -f drivers/firmware/google/Kconfig
> > linux-kernel@vger.kernel.org (open list)
> > 
> > I wonder why he's not listed as a recipient for patches from 
> > get_maintainer.pl since it's clearly obvious he wrote the entire file.
> 
> I do wish get_maintainer was better about this.  You can apparently
> make it dtrt with funky arguments, but --git-since and --git aren't
> working for me.
> 
> get_maintainer's default output should answer the question "who do I
> email about this file", and that ain't working :(
> 

I also think it would be great if get_maintainer's output was friendlier 
so that I can just copy a comma-separated line of "name <email>, name2 
<email2>" into my email client.
