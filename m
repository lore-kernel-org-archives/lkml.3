Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaAWVtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:49:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaAWVtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:49:12 -0500
Date: Thu, 23 Jan 2014 13:49:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mike Waychison <mikew@google.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] firmware/google: drop 'select EFI' to avoid recursive
 dependency
Message-Id: <20140123134910.144a70cc0fd4c02ba0f14de4@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1401231334540.7313@chino.kir.corp.google.com>
References: <1390473588-23367-1-git-send-email-ard.biesheuvel@linaro.org>
	<alpine.DEB.2.02.1401231334540.7313@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 13:36:55 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> $ ./scripts/get_maintainer.pl -f drivers/firmware/google/Kconfig
> linux-kernel@vger.kernel.org (open list)
> 
> I wonder why he's not listed as a recipient for patches from 
> get_maintainer.pl since it's clearly obvious he wrote the entire file.

I do wish get_maintainer was better about this.  You can apparently
make it dtrt with funky arguments, but --git-since and --git aren't
working for me.

get_maintainer's default output should answer the question "who do I
email about this file", and that ain't working :(

