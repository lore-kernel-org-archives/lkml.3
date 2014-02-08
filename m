Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaBHH6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:58:46 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:63387 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaBHH6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:58:45 -0500
MIME-Version: 1.0
X-Originating-IP: [42.61.198.132]
Date: Sat, 8 Feb 2014 15:58:44 +0800
Message-ID: <CAMVG2suzT1vphjHAUFCsbVBsd22U69jzQaKVwnEyGLBu6eGOSw@mail.gmail.com>
Subject: nouveau graphical corruption in 3.13.2
From: Daniel J Blueman <daniel@quora.org>
To: nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

With a GeForce 320M GPU running linux 3.13.2 and Xorg 1.15.0, I'm
seeing significant graphical corruption and later unrecoverable GPU
lockup, accompanied by thousands of ILLEGAL_MTHD or related kernel
messages [1]. I see similar issues on 3.12 also.

Is there any debugging or testing I can do to help diagnose this?

Many thanks,
  Daniel

--- [1]

http://quora.org/nouveau-dmesg.txt
http://quora.org/nouveau-Xorg.0.log
-- 
Daniel J Blueman
