Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935205Ab3IDPxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:53:38 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:41762 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934941Ab3IDPxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:53:36 -0400
MIME-Version: 1.0
In-Reply-To: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
Date: Wed, 4 Sep 2013 08:53:35 -0700
X-Google-Sender-Auth: i7rfWqHk0c8iDnH3gK7uZvygYOw
Message-ID: <CAGXu5jLCTU1MG4fYDzpT=TAP9DRAUuRuhZNB+edJsOzN4iXbDw@mail.gmail.com>
Subject: Re:
From: Kees Cook <keescook@chromium.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 4:50 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> We have two in-kernel mechanisms for restricting module loading - disabling
> it entirely, or limiting it to the loading of modules signed with a trusted
> key. These can both be configured in such a way that even root is unable to
> relax the restrictions.
>
> However, right now, there's several other straightforward ways for root to
> modify running kernel code. At the most basic level these allow root to
> reset the configuration such that modules can be loaded again, rendering
> the existing restrictions useless.
>
> This patchset adds additional restrictions to various kernel entry points
> that would otherwise make it straightforward for root to disable enforcement
> of module loading restrictions. It also provides a patch that allows the
> kernel to be configured such that module signing will be automatically
> enabled when the system is booting via UEFI Secure Boot, allowing a stronger
> guarantee of kernel integrity.
>
> V3 addresses some review feedback and also locks down uswsusp.

Looks good to me. Consider the entire series:

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
