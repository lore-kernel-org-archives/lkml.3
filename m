Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3JXHqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:46:25 -0400
Received: from mout.gmx.net ([212.227.17.20]:59218 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab3JXHqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:46:24 -0400
MIME-Version: 1.0
Message-ID: <trinity-70027928-c00c-449a-8386-1eae281e1bd5-1382600782364@3capp-gmx-bs62>
From: "Peter Huewe" <PeterHuewe@gmx.de>
To: "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>
Cc: "Ashley Lai" <adlai@linux.vnet.ibm.com>, "Rajiv Andrade" <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Aw: Re: [tpmdd-devel] [PATCH] tpm: MAINTAINERS: Add myself as tpm
 maintainer
Content-Type: text/plain; charset=UTF-8
Date: Thu, 24 Oct 2013 09:46:22 +0200 (CEST)
Importance: normal
Sensitivity: Normal
In-Reply-To: <20131024041620.GA32346@obsidianresearch.com>
References: <1382463410-2018-1-git-send-email-peterhuewe@gmx.de>
 <20131022205205.GA2374@obsidianresearch.com>
 <CAEQAOwoFpiVeDKTa6UgjiRoy9aKcUPHT7CYwa1eM1EUVm0gM=Q@mail.gmail.com>
 <trinity-2863d941-7421-4bbb-8c72-4bf491937d37-1382569828674@3capp-gmx-bs20>
 <20131024032736.GC30090@obsidianresearch.com>
 <1382587279.5587.9.camel@fishsauce>,
 <20131024041620.GA32346@obsidianresearch.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:RkyoQR4nTk5QfX7mkUaAmpvK7jkVp7zR72DVqpSQJ+y
 xI/OrD4gmO0mmlgxsn0vFWDRr94etYEqCueloFSJD49dtYnvkm
 takYrjDHwP6kN9KLWukScY2fiBkyKwDQ+1phzLMDIZ3Uw++KKA
 dJYXO1rbEdCg2r+VDpsMLpBm7mxnOQioy/rYVOSeYQqf8PmFNe
 ghQubcZTuoKz0/+803PEdxxewUFy/iK7AVIAhrsVPYMUVhmduo
 U3+MPaxGgQ1Cpw5SNXQGg5wVAWamxj6ulp8rHj4Y6P5/+wtRf0 XxNI+M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

> > Speaking of which, has anyone looked at the rest of my series?? Shall
> > I repost it?
> Jason Gunthorpe:
> tpm: Pull everything related to /dev/tpmX into tpm-dev.c
> tpm: Pull everything related to sysfs into tpm-sysfs.c
> tpm: Create a tpm_class_ops structure and use it in the drivers
> tpm: Use the ops structure instead of a copy in tpm_vendor_specific
> tpm: Make tpm-dev allocate a per-file structure

> Peter's checkpatch clean up will create some minor conflicts, so I
> should probably resend the lot after rebasing it.

Yeah that would be nice.

I did have a look at them, but not as close as I wanted to, yet ;(
Since they are making some major changes to the tpm subsystem I did not want to hurry them in for 3.12, but give them a rather good testing on my machines as well. (I know you did test them ;)

Unfortunately due to a lot of traveling that was not possible for me.
So please repost them, so we can make them ready for 3.13.

Thanks,
Peter
