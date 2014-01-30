Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaA3EyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 23:54:07 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:48344 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaA3EyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 23:54:05 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
Date: Wed, 29 Jan 2014 20:54:03 -0800
X-Google-Sender-Auth: DLDEd85IoTc1iwHfb_81PK19c9U
Message-ID: <CA+55aFwfd2CN3eYee0WeUfaZj59+2wJ9nr9uhvzVVQ5ZQkn7yA@mail.gmail.com>
Subject: Re: [git pull] drm next tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 6:49 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> For some reason the request-pull and the merge into your tree look different,
> since some of the changes in this have already gone in via the arm-soc tree
> and dma stuff, all for tegra. Hopefully nobody rebased when they shouldn't.

Looks more like it's just a few cross-merges, which then ends up
meaning that there are multiple merge-bases and not just one common
ancestor commit.

In that case, a simple "git diff" can't do a great job, and the actual
merge diff will usually end up different.

                     Linus
