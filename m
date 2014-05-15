Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaEORjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:39:22 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:44488 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaEORjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:39:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140515164703.73a1cf06@canb.auug.org.au>
References: <20140515164703.73a1cf06@canb.auug.org.au>
Date: Thu, 15 May 2014 10:39:20 -0700
Message-ID: <CAM_iQpU84BD4WjTEW0Yn6-R3ocHh25quAj_F8cmkVK=CRZd9Kg@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the net-next tree
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 11:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the net-next tree, today's linux-next build (powerpc
> allnoconfig) produced this warning:
>
>
> include/net/ip.h:211:5: warning: "CONFIG_SYSCTL" is not defined [-Wundef]
>  #if CONFIG_SYSCTL
>      ^
>
> Introduced by commit 122ff243f5f1 ("ipv4: make ip_local_reserved_ports
> per netns").


Oops, blame my fat fingers... Just s/#if/#ifdef/. ;)
