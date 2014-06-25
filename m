Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbaFYMkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:40:08 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50466 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbaFYMkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:40:06 -0400
Date: Wed, 25 Jun 2014 13:39:30 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Tomasz Torcz <tomek@pipebreaker.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: disable console blanking by default
Message-ID: <20140625133930.223cccb5@alan.etchedpixels.co.uk>
In-Reply-To: <20140618092730.GD22226@mother.pipebreaker.pl>
References: <20140618092730.GD22226@mother.pipebreaker.pl>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014 11:27:31 +0200
Tomasz Torcz <tomek@pipebreaker.pl> wrote:

> 
> >From ea7cf47e3230eda63aa6c46092719437f9bbae8e Mon Sep 17 00:00:00 2001
> From: Tomasz Torcz <tomek@pipebreaker.pl>
> Date: Wed, 18 Jun 2014 11:18:06 +0200
> Subject: [PATCH] vt: disable console blanking by default
> 
>   Remove default 10 minute blank interval. Instead: never blank by
>   default.
>   "Screensaving" is no longer useful.  Today it only provides
>   obstacle when interacting with text console, especially through
>   remote lights-out management solutions.

Screensaving is extremely useful as is power management, and power prices
are going up not down. We don't customise the upstream kernel just
because J Random User happens to want his defaults.

There are a couple of things you can sensibly do

1. Just turn it off in software. It's run time configurable via setterm

2. If you have a reliable way of detecting the presence of a remote
console device and that device supports reporting when a connection is
made/broken you could submit a patch to make it unblank on connect.

Alan
