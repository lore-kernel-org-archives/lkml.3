Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab3FMPXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:23:08 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:61870 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3FMPXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:23:03 -0400
MIME-Version: 1.0
Date: Thu, 13 Jun 2013 18:23:02 +0300
Message-ID: <CA+ydwtrDxmywNPmJZqviYWNPUhati=Khq764cDN06uKKRo3xUQ@mail.gmail.com>
Subject: =?windows-1252?Q?sound=2Foss=2Fad1848=2Ec=3A2867=3A32=3A_warning=3A_=91id=5Ftable=92_?=
	=?windows-1252?Q?defined_but_not_used?=
From: Tommi Rantala <tt.rantala@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I'm seeing the following compiler warning, does it look useful?
I'm doing a v3.10-rc5 x86-64 build.

/build/linux/sound/oss/ad1848.c:2867:32: warning: ‘id_table’ defined
but not used [-Wunused-variable]

$ gcc --version
gcc (Ubuntu/Linaro 4.7.3-1ubuntu1) 4.7.3
Copyright (C) 2012 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

config:
http://fpaste.org/18443/13711363/

Tommi
