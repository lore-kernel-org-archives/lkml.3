Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaHOQW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:22:56 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55033 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaHOQWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:22:54 -0400
Date: Fri, 15 Aug 2014 09:23:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Colin Cross <ccross@google.com>, John Stultz <john.stultz@linaro.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/2] android: add sync_fence_create_dma
Message-ID: <20140815092320.39d28726@jbarnes-desktop>
In-Reply-To: <20140815064656.GB20920@kroah.com>
References: <53EC8722.4070407@canonical.com>
	<53EC876C.9050705@canonical.com>
	<20140815064656.GB20920@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2014 14:46:56 +0800
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Thu, Aug 14, 2014 at 11:54:52AM +0200, Maarten Lankhorst wrote:
> > This allows users of dma fences to create a android fence.
> 
> Who is going to use these functions?  I need an in-kernel user before I
> can add new api calls.

I have some code that uses them, but I need a userspace user to push my
stuff. :)

I'm working on the latter bit too in Mesa, and we have demand from
Android, so we should get some users shortly.

-- 
Jesse Barnes, Intel Open Source Technology Center
