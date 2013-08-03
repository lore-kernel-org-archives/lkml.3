Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab3HCNw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 09:52:26 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33378 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3HCNwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 09:52:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1308031534390.1352@math.ut.ee>
References: <alpine.SOC.1.00.1308031534390.1352@math.ut.ee>
Date: Sat, 3 Aug 2013 09:52:24 -0400
Message-ID: <CADnq5_MzA_oUttcygUswHt7ztwZ2yq62rwx-HS632CwpsGuVjw@mail.gmail.com>
Subject: Re: 3.11-rc3+git: __divdi3 undefined on powerpc (from radeon)
From: Alex Deucher <alexdeucher@gmail.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 3, 2013 at 8:44 AM, Meelis Roos <mroos@linux.ee> wrote:
> While trying to compile v3.11-rc3-288-gabe0308 on powerpc 32-bit,
> it failed with the following linking error:
>
> ERROR: "__divdi3" [drivers/gpu/drm/radeon/radeon.ko] undefined!
>
> Some new 64-bit division in radeon that is not implemented on 32-bit
> powerpc?
>
> This is new - 3.11-rc3 worked fine.

Fix is already queued:
http://lists.freedesktop.org/archives/dri-devel/2013-August/042668.html

Alex

>
> --
> Meelis Roos (mroos@linux.ee)
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
