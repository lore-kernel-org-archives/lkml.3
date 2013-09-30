Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3I3Lcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:32:42 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53974 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab3I3Lcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:32:39 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1380540373-25352-4-git-send-email-treding@nvidia.com>
References: <1380540373-25352-1-git-send-email-treding@nvidia.com>
	<1380540373-25352-4-git-send-email-treding@nvidia.com>
Date: Mon, 30 Sep 2013 13:32:38 +0200
Message-ID: <CAKMK7uHpz3AbsdxZR84AHDzAg9k3DHU8p81-jWD5samOq-2Naw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the drm-intel tree
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 1:26 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> Today's linux-next merge of the drm-intel tree got conflicts in
>
>         drivers/gpu/drm/i915/intel_display.c
>
> I fixed it up (see below). Please check if the resolution looks correct.

Looks good.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
