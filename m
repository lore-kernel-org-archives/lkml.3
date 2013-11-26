Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab3KZB07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:26:59 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:63354 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3KZB06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:26:58 -0500
MIME-Version: 1.0
In-Reply-To: <20131125203755.GA14140@kroah.com>
References: <1385044966-3572-1-git-send-email-bergwolf@gmail.com> <20131125203755.GA14140@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Tue, 26 Nov 2013 09:26:37 +0800
Message-ID: <CA+a=Yy5RtqW1aaQcE2ehskbWo6XCTRKK9-e_83wC=e2H72rsRA@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging/lustre/ptlrpc: fix ptlrpc_stop_pinger logic
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 4:37 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 21, 2013 at 10:42:45PM +0800, Peng Tao wrote:
>> It was introduced due to a patch hunk when porting
>> commit 20802057 (staging/lustre/ptlrpc: race in pinger).
>
> This patch was in 3.12, so this needs to go to the stable tree for 3.12,
> right?  It also needs to get into 3.13-final, so please tell me that
> next time so I know where to apply it to.
>
Thank you for helping add the stable tag. I will remember to add it next time.

Thanks,
Tao
