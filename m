Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaIDVMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:12:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbaIDVMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:12:16 -0400
Date: Thu, 4 Sep 2014 14:12:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] kernel: add support for gcc 5
Message-Id: <20140904141215.9e6125150824d0768aedbfcb@linux-foundation.org>
In-Reply-To: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>
References: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Sep 2014 11:37:19 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> We're missing include/linux/compiler-gcc5.h which is required now
> because gcc branched off to v5 in trunk.
> 
> Just copy the relevant bits out of include/linux/compiler-gcc4.h,
> no new code is added as of now.
> 
> This fixes a build error when using gcc 5.

I think I'll stick a cc:stable on this one, as people will presumably
wish to compile older kernels with newer gcc's at some time in the
future.

