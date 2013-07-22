Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab3GVVYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:24:53 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:33621 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034Ab3GVVYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <1374526866-6813-1-git-send-email-bp@alien8.de>
References: <1374526866-6813-1-git-send-email-bp@alien8.de>
Date: Mon, 22 Jul 2013 14:24:51 -0700
X-Google-Sender-Auth: bzpnmMZ-2P-iHreJ8XiKX-VPACs
Message-ID: <CAGXu5j+M7ORqYLZXQLVn4-c9W3X0jW7Or0AW-SRHWds7OEydVg@mail.gmail.com>
Subject: Re: [PATCH] APEI/ERST: Fix error message formatting
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 2:01 PM, Borislav Petkov <bp@alien8.de> wrote:
> From: Borislav Petkov <bp@suse.de>
>
> [    5.525861] ERST: Can not request iomem region <0x        c7eff000-0x        c7f00000> for ERST.
>
> This needs to have leading zeroes. Make it so.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Anton Vorontsov <anton@enomsg.org>
> Cc: Colin Cross <ccross@android.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Yes, please. :) Nice catch.

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
