Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaJJVQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:16:10 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:46663 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaJJVQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:16:08 -0400
MIME-Version: 1.0
In-Reply-To: <20141008094858.759d0597@canb.auug.org.au>
References: <20141008094858.759d0597@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 10 Oct 2014 22:15:47 +0100
X-Google-Sender-Auth: VUcFHL63b8M7d53iJvjQGmh7j9s
Message-ID: <CACxGe6toD+rCS4eS1n4gtNj99o6mQxoB_MKVxBU-k-R9H-3wjA@mail.gmail.com>
Subject: Re: linux-next: error fetching the devicetree tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Yes, the server is down and being worked on. I've moved my tree to
kernel.org. Here is the new URL:

git://git.kernel.org/pub/scm/linux/kernel/git/glikely/linux.git

g.


On Tue, Oct 7, 2014 at 11:48 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Fetching the devicetree tree this morning produced this error:
>
> fatal: unable to connect to git.secretlab.ca:
> git.secretlab.ca[0: 208.123.74.12]: errno=Connection timed out
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
