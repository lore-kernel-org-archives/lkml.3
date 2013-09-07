Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab3IGQyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 12:54:51 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:47705 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3IGQyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 12:54:50 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <522A5008.6060005@t-online.de>
References: <522A5008.6060005@t-online.de>
Date: Sat, 7 Sep 2013 18:54:49 +0200
X-Google-Sender-Auth: T4h-4q4NiCCKYKpqz4CgA11BMiU
Message-ID: <CAKMK7uHAMr_qzismVMB8m3za8UwogMVknPcj7LsZFuC7L8GnrQ@mail.gmail.com>
Subject: Re: [Intel-gfx] [BUG kernel 3.11+] i915: pipe state doesn't match
From: Daniel Vetter <daniel@ffwll.ch>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 11:58 PM, Knut Petersen
<Knut_Petersen@t-online.de> wrote:
> Someone might be interested ... kernel
> 2e032852245b3dcfe5461d7353e34eb6da095ccf.
>
> [    0.000000] Linux version 3.11.0-main+ (knut@linux-ktth.site) (gcc
> version 4.7.2 20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #34
> PREEMPT Fri Sep 6 09:46:35 CEST 2013


http://cgit.freedesktop.org/~danvet/drm-intel/commit/?id=4c6df4b4ca1b26f4532d403b544f649a1c801fd1

could be of interest for you. If that doesn't help please boot with
drm.debug=0xe and attach the complete dmesg.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
