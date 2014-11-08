Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaKHSgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:36:37 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:40656 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaKHSgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:36:36 -0500
MIME-Version: 1.0
Date: Sat, 8 Nov 2014 19:36:34 +0100
Message-ID: <CA+i8gK+9Mm1Sc7Qk1aRy7MtKC_ApJ89FL_ZSKEg1fKCo3sDjCA@mail.gmail.com>
Subject: [Regression] 83f45fc turns machine's screen off
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: airlied@linux.ie, daniel.vetter@ffwll.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following commit permanently turns my screen off when x server is
started (i3 330M Ironlake):

    [83f45fc360c8e16a330474860ebda872d1384c8c] drm: Don't grab an fb
reference for the idr

Reverting this commit fixed the issue.

Thanks in advance.
Emmanuel
