Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaE1Jwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:52:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39156 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaE1Jwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:52:31 -0400
Date: Wed, 28 May 2014 11:52:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mathieu Souchaud <mattieu.souchaud@free.fr>
Cc: tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] x86/mce: Improve mcheck_init_device() error handling
Message-ID: <20140528095227.GA17196@pd.tnic>
References: <1401261157-1165-1-git-send-email-mattieu.souchaud@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401261157-1165-1-git-send-email-mattieu.souchaud@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 09:12:37AM +0200, Mathieu Souchaud wrote:
> Check return code of every function called by mcheck_init_device().
> 
> Signed-off-by: Mathieu Souchaud <mattieu.souchaud@free.fr>

Applied, thanks!

I'll queue it for 3.17 though since we're very close to the 3.16 merge
window and this patch hasn't had any linux-next time.

Thanks for your good work, let me know if you want to do more around mce.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
