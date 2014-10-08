Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaJHXLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 19:11:45 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:54929 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaJHXLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 19:11:42 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:91a6:e9a:69b6:c0e5]
In-Reply-To: <5435AABC.2010902@zytor.com>
References: <CA+5PVA5BeRMd28CUZPj+G2VbcwT0pG7gERk65xdMLXSp_59-RA@mail.gmail.com>
 <CALCETrUDkHH-FLwq9ZJ0wFeOkQVWUjTh-cJPL4Jq28sHCqhfFA@mail.gmail.com>
 <20141008154659.31f46436@as> <5435A4A4.1070101@zytor.com> <20141008160956.7584d303@as>
 <5435AABC.2010902@zytor.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Wed, 8 Oct 2014 19:11:21 -0400
Message-ID: <CAOFdcFN4jBvATfBNbccpARf4DRXAhCy1wf8FNKLhudKnutPd6Q@mail.gmail.com>
Subject: Re: vdso_standalone_test_x86.c build failure on Linus' tree
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Randy Dunlap <rdunlap@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 5:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> That we can't solve, but it is not okay to break the kernel build.

Should I just make CONFIG_BUILD_DOCSRC depend on CROSS_COMPILE=""?
I'm not sure how much value would be added by implementing targetprogs
in kbuild, simply to increase build testing of Documentation/
