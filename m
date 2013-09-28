Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3I1Ukn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 16:40:43 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:38323 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3I1Ukl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 16:40:41 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <52473D1C.5010003@gmail.com>
References: <52442A3C.3010407@gmail.com>
	<CAKMK7uFvP7zisHL4UFjRqBX8mxS4DtosF2AFnwZDSdMgnDf4Lw@mail.gmail.com>
	<5245C004.7070907@gmail.com>
	<CAKMK7uFZ35gruMYHB+LXEDVoAof7n-1oYGxWkky_tLe3ELLxWQ@mail.gmail.com>
	<52473D1C.5010003@gmail.com>
Date: Sat, 28 Sep 2013 22:40:40 +0200
Message-ID: <CAKMK7uGr2MavtS11HRtJxqL3u2f9==_=EMavy6BBCGswz4rNhA@mail.gmail.com>
Subject: Re: 3.12 regression: i915 warnings
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Woody Suwalski <terraluna977@gmail.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 10:33 PM, Woody Suwalski <terraluna977@gmail.com> wrote:
> Warnings are gone with this patch (and other 4 patches  since 3.2.12-rc2
> from drm tree).

Ok, fix should land in stable kernels soonish (depends upon how
quickly the pull request propagate). Thanks for reporting this issue
and testing the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
