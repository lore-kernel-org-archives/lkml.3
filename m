Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaBUAOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:14:03 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:51509 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbaBUAOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 19:14:00 -0500
MIME-Version: 1.0
In-Reply-To: <1392848019-24114-1-git-send-email-stefan.seyfried@googlemail.com>
References: <1392848019-24114-1-git-send-email-stefan.seyfried@googlemail.com>
Date: Thu, 20 Feb 2014 16:13:59 -0800
X-Google-Sender-Auth: flpzfk9xRx67wqt-O3g_btTcRII
Message-ID: <CAGXu5jLBG50B7bn8gdps4YTJBOjWpGJTtxWUBqFC9UKbs93oPw@mail.gmail.com>
Subject: Re: [PATCH] Makefile: fix syntax error in warning message
From: Kees Cook <keescook@chromium.org>
To: stefan.seyfried@googlemail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Stefan Seyfried <seife+kernel@b1-systems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 2:13 PM,  <stefan.seyfried@googlemail.com> wrote:
> From: Stefan Seyfried <seife+kernel@b1-systems.com>
>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 893d6f0..eeaf3e7 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -606,7 +606,7 @@ ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
>    stackp-flag := -fstack-protector
>    ifeq ($(call cc-option, $(stackp-flag)),)
>      $(warning Cannot use CONFIG_CC_STACKPROTECTOR: \
> -             -fstack-protector not supported by compiler))
> +             -fstack-protector not supported by compiler)
>    endif
>  else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
>    stackp-flag := -fstack-protector-strong

Hi!

Thanks, yes, this has already been picked up:
http://marc.info/?l=linux-mm-commits&m=139275774732494&w=2

-Kees

-- 
Kees Cook
Chrome OS Security
