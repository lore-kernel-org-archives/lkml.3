Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965001AbaDIVCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:02:08 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64060 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaDIVCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:02:06 -0400
MIME-Version: 1.0
In-Reply-To: <9443.1397067600@turing-police.cc.vt.edu>
References: <9443.1397067600@turing-police.cc.vt.edu>
Date: Wed, 9 Apr 2014 14:02:04 -0700
Message-ID: <CA+8MBb+Od9wRT-L4KhrNgqwCyHx_R4vS_k1gouAjaxMZPaLKFg@mail.gmail.com>
Subject: Re: pstore wierdness on Dell Latitude E6530.
From: Tony Luck <tony.luck@gmail.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 11:20 AM, Valdis Kletnieks
<Valdis.Kletnieks@vt.edu> wrote:
> For some reason, /sys/fs/pstore has 537 files in it, all called 'console-efi',

> Any ideas?

Take a look at this thread: https://lkml.org/lkml/2013/10/30/83

I think there were some bugs in the console-efi code a while
back - perhaps you ran a kernel had the bug and made all these
duplicate entries?

-Tony
