Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3AYAvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:51:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab3AYAu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:50:57 -0500
Date: Thu, 24 Jan 2013 16:50:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: Re: [git pull] fbcon locking fixes.
Message-Id: <20130124165055.0bceb033.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1301250041001.25545@skynet.skynet.ie>
References: <alpine.DEB.2.00.1301250041001.25545@skynet.skynet.ie>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013 00:42:37 +0000 (GMT)
Dave Airlie <airlied@linux.ie> wrote:

> These patches have been sailing around long enough, waiting for a maintainer
> to reappear, so I've decided enough is enough, lockdep is kinda useful to have.
> 
> Thanks to Daniel for annoying me enough :-)

Me too, but the patches broke Maarten's EFI driver setup:
https://lkml.org/lkml/2013/1/15/203.
