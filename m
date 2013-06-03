Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3FCBYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 21:24:13 -0400
Received: from blu0-omc2-s37.blu0.hotmail.com ([65.55.111.112]:42331 "EHLO
	blu0-omc2-s37.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755323Ab3FCBYC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 21:24:02 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Jun 2013 21:24:02 EDT
X-TMN: [xmjdcG6BFVfKub3fpq4oLdXw8a3qxkUl]
X-Originating-Email: [yuhongbao_386@hotmail.com]
Message-ID: <BLU177-W3672A7BA58CC4EE16F4EEAC39D0@phx.gbl>
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu>
Subject: RE: IO regression after ab8fabd46f on x86 kernels with high memory
Date: Sun, 2 Jun 2013 18:17:51 -0700
Importance: Normal
In-Reply-To: <518AA321.6070900@zytor.com>
References: <517B1153.8000401@valvesoftware.com> <517B2FB4.30605@redhat.com>
 <20130427024248.GA1229@cmpxchg.org> <517EEBD1.503@valvesoftware.com>
 <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com>,<518AA321.6070900@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 03 Jun 2013 01:17:52.0971 (UTC) FILETIME=[2BAE89B0:01CE5FF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We kernel guys have been asking the distros to ship 64-bit kernels even
> in their 32-bit distros for many years, but concerns of compat issues
> and the desire to deprecate 32-bit userspace seems to have kept that
> from happening.

And now there is another reason: to call 64-bit EFI runtime services.
In retrospect, I would have stuck with 32-bit EFI with 64-bit kernels calling runtime services in compatibility mode, but of course it is too late for that now.

Yuhong Bao 		 	   		  