Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbaJWSw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:52:26 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38091 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbaJWSwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:52:22 -0400
MIME-Version: 1.0
In-Reply-To: <1414085351.15751.10.camel@perches.com>
References: <874muwv0ym.fsf@intel.com>
	<1413980418.18654.8.camel@perches.com>
	<87ppdktewn.fsf@intel.com>
	<1414085351.15751.10.camel@perches.com>
Date: Thu, 23 Oct 2014 11:52:22 -0700
X-Google-Sender-Auth: 8nHW67QspusMLeEhrqMkY-eTfq4
Message-ID: <CAGXu5jKu5=r_Ua6xKGywX-4JUesNhQo_CP0CjCPEMoqvLRPa7A@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: fix use via symlink, make missing spelling
 file non-fatal
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 10:29 AM, Joe Perches <joe@perches.com> wrote:
> Commit 66b47b4a9dad ("checkpatch: look for common misspellings")
> made it difficult to use checkpatch via a symlink.
>
> Fix that and make a missing spelling.txt file non-fatal.
> Emit a warning when the spelling.txt file can not be opened.
>
> Reference: http://xkcd.com/1172/
>
> Signed-off-by: Joe Perches <joe@perches.com>
> Reported-by: Jani Nikula <jani.nikula@intel.com>
> Tested-by: Jani Nikula <jani.nikula@intel.com>

Thanks for fixing this. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
