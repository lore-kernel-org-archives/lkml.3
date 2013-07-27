Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3G0Psq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 11:48:46 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:39277 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3G0Psp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 11:48:45 -0400
Message-ID: <51F3EA2A.3090905@gmail.com>
Date: Sat, 27 Jul 2013 17:41:30 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, criu@openvz.org, devel@openvz.org,
        xemul@parallels.com
Subject: Re: [PATCH RFC] pram: persistent over-kexec memory file system
References: <1374841763-11958-1-git-send-email-vdavydov@parallels.com>
In-Reply-To: <1374841763-11958-1-git-send-email-vdavydov@parallels.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/07/2013 14:29, Vladimir Davydov ha scritto:
> Hi,
>
> We want to propose a way to upgrade a kernel on a machine without
> restarting all the user-space services. This is to be done with CRIU
> project, but we need help from the kernel to preserve some data in
> memory while doing kexec.
>
> The key point of our implementation is leaving process memory in-place
> during reboot. This should eliminate most io operations the services
> would produce during initialization. To achieve this, we have
> implemented a pseudo file system that preserves its content during
> kexec. We propose saving CRIU dump files to this file system, kexec'ing
> and then restoring the processes in the newly booted kernel.
>

http://pramfs.sourceforge.net/

Marco

