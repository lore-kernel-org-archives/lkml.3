Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab3GCNUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:20:23 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41274 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3GCNUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:20:22 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Alex Deucher'" <alexdeucher@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Subject: RE: 3.10 kernel: [drm:evergreen_startup] *ERROR* radeon: error initializing UVD (-1). [SOLVED]
Date: Wed, 3 Jul 2013 09:20:19 -0400
Message-ID: <005201ce77f0$11f2bc20$35d83460$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac537/KGFr+jLTgPTw6zgyhKfzV7PQ==
Content-language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Alex Deucher [mailto:alexdeucher@gmail.com] 
Sent: Tuesday, July 02, 2013 3:41 PM
To: Justin Piszcz
Cc: linux-kernel@vger.kernel.org; dri-devel@lists.freedesktop.org
Subject: Re: 3.10 kernel: [drm:evergreen_startup] *ERROR* radeon: error
initializing UVD (-1).

Please open a bug (product: DRI, component: DRM/Radeon):
https://bugs.freedesktop.org
and attach your dmesg output and xorg log.

Alex

Per:
https://bugs.freedesktop.org/show_bug.cgi?id=66519

Grabbed firmware, removed distribution firmware package, re-built kernel and
all is working now, thanks!

Justin.



