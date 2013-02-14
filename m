Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253Ab3BNOMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:12:06 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63201 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab3BNOME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:12:04 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
Date: Thu, 14 Feb 2013 15:12:02 +0100
Message-ID: <CAKMK7uEQ7xQpsBay8SKjYM0oA0=uf3AePwZ+vEjukgOiLY9drg@mail.gmail.com>
Subject: Including drm-intel tree to linux-next
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: rostedt@goodmis.org
Cc: Dave Airlie <airlied@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Since about a year ago we've switched drm/i915 to buffer around 2
weeks worth of patches so that we can do decent QA before breaking
everyone's tree when things land in Dave's drm-next. But that also
means we'll miss out a bit in the integration testing -next provides,
which did hurt a bit in recent efforts. Hence can you please include

git://people.freedesktop.org/~danvet/drm-intel drm-intel-next-queued

into linux-next? Probably best to merge it after drm-next. Note that
drm-intel-next are the QA'ed chunks I send off to Dave. Also, any
mailing lists I'm supposed to follow? And if possible please cc
intel-gfx@lists.freedesktop.org besides dri-devel/lkml when conflicts
with that tree pop up (you won't get moderation spam any more, we've
fixed that up).

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
