Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaAHRrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:47:47 -0500
Received: from smtprelay0018.hostedemail.com ([216.40.44.18]:43524 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751070AbaAHRrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:47:45 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:599:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:7652:7875:7903:9025:10004:10400:10848:11026:11232:11658:11854:11914:12043:12291:12296:12517:12519:12683:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: food11_263b6dcee8912
X-Filterd-Recvd-Size: 1683
Message-ID: <1389203262.24222.3.camel@joe-AO722>
Subject: Re: [PATCH -next 0/4] fs: Use seq_is_buf_full
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Date: Wed, 08 Jan 2014 09:47:42 -0800
In-Reply-To: <cover.1386891757.git.joe@perches.com>
References: <cover.1386819513.git.joe@perches.com>
	 <cover.1386891757.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-12 at 15:47 -0800, Joe Perches wrote:
> Convert the fs uses and misuses of seq_printf to void
> 
> These patches depend on https://lkml.org/lkml/2013/12/11/714
> 
> Joe Perches (4):
>   dlm: Use seq_is_buf_full - remove seq_printf returns
>   dlm: Use seq_puts, remove unnecessary trailing spaces
>   fs: Convert show_fdinfo functions to void
>   debugfs: Fix misuse of seq_printf return value

Ping?

>  fs/debugfs/file.c  |  14 +--
>  fs/dlm/debug_fs.c  | 274 +++++++++++++++++++++++++----------------------------
>  fs/eventfd.c       |  15 +--
>  fs/eventpoll.c     |  19 ++--
>  fs/notify/fdinfo.c |  68 ++++++-------
>  fs/notify/fdinfo.h |   4 +-
>  fs/proc/fd.c       |   2 +-
>  fs/signalfd.c      |  10 +-
>  include/linux/fs.h |   2 +-
>  9 files changed, 184 insertions(+), 224 deletions(-)
> 



