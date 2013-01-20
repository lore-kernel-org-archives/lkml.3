Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3ATVTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 16:19:30 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:47877 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab3ATVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 16:19:29 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130120153209.GA2881@biers.ffwll.ch>
References: <20130120153209.GA2881@biers.ffwll.ch>
Date: Sun, 20 Jan 2013 22:19:27 +0100
X-Google-Sender-Auth: Ror1AieS2BrQGDerswg03MxIJno
Message-ID: <CAKMK7uHf91QQhzcJftbzkAtSGQ5MyQmZu9CY-Q_kOBMyR5vVGQ@mail.gmail.com>
Subject: Re: [PULL] kms locking rework
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 4:32 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> Changes since the patchbomb on dri-devel:
> - Added a patch to adjust the new omapdrm code in 3.8-rc4, reviewed by Rob
>   Clark on irc (hence also why the baseline of this pull is 3.8-rc4).
> - Slightly fixed/clarified some commit messages and fixed one spelling
>   fail in a comment.
> - Sprinkled Rob's r-b tags over the patches (for drm core changes +
>   omapdrm).

I've updated the pull with a tiny change to fix up the kerneldoc for
drm_modeset_unlock_all - I've mislabelled one of the arguments.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
