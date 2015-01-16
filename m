Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbbAPHQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:16:39 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36067 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbbAPHQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:16:37 -0500
Subject: Re: linux-next: build failure after merge of the i2c tree
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20150116132253.1c5f7a8d@canb.auug.org.au>
Date: Fri, 16 Jan 2015 09:16:33 +0200
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A7E15511-DF00-40D4-91CC-660038F5A71F@konsulko.com>
References: <20150116132253.1c5f7a8d@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> On Jan 16, 2015, at 04:22 , Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> Hi Wolfram,
> 
> After merging the i2c tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/i2c/i2c-core.c: In function 'i2c_unregister_device':
> drivers/i2c/i2c-core.c:1016:3: error: implicit declaration of function 'of_node_clear_flag' [-Werror=implicit-function-declaration]
>   of_node_clear_flag(client->dev.of_node, OF_POPULATED);
>   ^
> drivers/i2c/i2c-core.c:1016:43: error: 'OF_POPULATED' undeclared (first use in this function)
>   of_node_clear_flag(client->dev.of_node, OF_POPULATED);
>                                           ^
> 
> Caused by commit d5285c36e6d2 ("i2c: Mark instantiated device nodes
> with OF_POPULATE").
> 
> I have used the version of the i2c tree from next-20150115 for today.

A patch that fixes it has already been posted.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 

Regards

— Pantelis

