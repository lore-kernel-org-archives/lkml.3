Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3GXSLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:11:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35628 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab3GXSLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:11:03 -0400
Date: Wed, 24 Jul 2013 20:10:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] APEI/ERST: Fix error message formatting
Message-ID: <20130724181056.GM30777@pd.tnic>
References: <1374526866-6813-1-git-send-email-bp@alien8.de>
 <20130724171347.GB29756@naverao1-tp.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130724171347.GB29756@naverao1-tp.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:43:47PM +0530, Naveen N. Rao wrote:
> While looking at this, I noticed that we seem to be using varying
> field widths in our APEI code: - einj.c has two instances using
> %#010llx. - apei-base.c uses widths of 10 (4 bytes) and 6 (2 bytes).
>
> Not sure if these are intentional and those fields truly aren't 64-bit
> (as suggested by the usage of long long int).

That's an interesting question but I think you're better fitted to
answer it - I try to avoid the APEI spec as much as possible.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
