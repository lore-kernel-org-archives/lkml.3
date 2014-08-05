Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaHEVqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:46:42 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:45853 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaHEVqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:46:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140725185048.GA27939@www.outflux.net>
References: <20140725185048.GA27939@www.outflux.net>
Date: Tue, 5 Aug 2014 14:46:39 -0700
X-Google-Sender-Auth: ZrGR9_RbTLc4Fo2HfTTVHGLrGL0
Message-ID: <CAGXu5jK--17NZvJK2BSWiANn4dkgLMUpGpoWrmy+jM=BfKkBxQ@mail.gmail.com>
Subject: Re: [PULL] fw-restrict update (3.17)
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 11:50 AM, Kees Cook <keescook@chromium.org> wrote:
> Hi James,
>
> Please pull these fw-restrict changes for 3.17. Thanks!

James, did this ever get pulled? Does it need more review?

Thanks!

-Kees

>
> -Kees
>
> The following changes since commit 7d8b6c63751cfbbe5eef81a48c22978b3407a3ad:
>
>   CAPABILITIES: remove undefined caps from all processes (2014-07-24 21:53:47 +1000)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/fw-restrict-3.17
>
> for you to fetch changes up to 5a9196d715607f76d6b7d96a0970d6065335e62b:
>
>   ima: add support for measuring and appraising firmware (2014-07-25 11:47:46 -0700)
>
> ----------------------------------------------------------------
> Firmware validation hooks
>
> ----------------------------------------------------------------
> Kees Cook (2):
>       security: introduce kernel_fw_from_file hook
>       firmware_class: perform new LSM checks
>
> Mimi Zohar (1):
>       ima: add support for measuring and appraising firmware
>
>  Documentation/ABI/testing/ima_policy  |  4 +++-
>  drivers/base/firmware_class.c         | 30 ++++++++++++++++++++++++++----
>  include/linux/ima.h                   |  6 ++++++
>  include/linux/security.h              | 17 +++++++++++++++++
>  security/capability.c                 |  6 ++++++
>  security/integrity/ima/ima.h          |  3 ++-
>  security/integrity/ima/ima_appraise.c |  8 ++++++++
>  security/integrity/ima/ima_main.c     | 11 +++++++++++
>  security/integrity/ima/ima_policy.c   |  7 +++++++
>  security/integrity/integrity.h        |  9 +++++++--
>  security/security.c                   | 11 +++++++++++
>  11 files changed, 104 insertions(+), 8 deletions(-)
>
> --
> Kees Cook
> Chrome OS Security



-- 
Kees Cook
Chrome OS Security
