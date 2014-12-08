Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbaLHUnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:43:06 -0500
Received: from mx2.comprocs.com ([12.186.155.30]:52929 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753148AbaLHUnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:43:05 -0500
X-BYPSHEADER: 3151324
X-SMScore: -200
Message-ID: <54860D53.1050800@compro.net>
Date: Mon, 08 Dec 2014 15:42:59 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: nouveau: Do you really want these new links in the kernel tree?
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/usr/src/linux-3.18> find drivers/ -type l | xargs ls -al

lrwxrwxrwx 1 markh users 21 Dec  7 17:21 ./drivers/gpu/drm/nouveau/core/include/nvif/class.h -> ../../../nvif/class.h
lrwxrwxrwx 1 markh users 21 Dec  7 17:21 ./drivers/gpu/drm/nouveau/core/include/nvif/event.h -> ../../../nvif/event.h
lrwxrwxrwx 1 markh users 21 Dec  7 17:21 ./drivers/gpu/drm/nouveau/core/include/nvif/ioctl.h -> ../../../nvif/ioctl.h
lrwxrwxrwx 1 markh users 22 Dec  7 17:21 ./drivers/gpu/drm/nouveau/core/include/nvif/unpack.h -> ../../../nvif/unpack.h
lrwxrwxrwx 1 markh users 12 Dec  7 17:21 ./drivers/gpu/drm/nouveau/nvif/os.h -> ../core/os.h

Regards
Mark
