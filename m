Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbaGQKNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:13:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33083 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbaGQKNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:13:01 -0400
Date: Thu, 17 Jul 2014 12:12:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v3 6/6] acerhdf: minor clean up
Message-ID: <20140717101257.GD23869@pd.tnic>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1399139966-10625-1-git-send-email-peter@piie.net>
 <1399139966-10625-7-git-send-email-peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1399139966-10625-7-git-send-email-peter@piie.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 07:59:26PM +0200, Peter Feuerer wrote:
>   * renamed bios_settings_t to bios_settings, as it is no typedef
>   * replaced "unsigned char" by u8 in bios_settings struct for better
>     readability.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andreas Mohr <andi@lisas.de>
> Cc: Borislav Petkov <bp@suse.de>
> Signed-off-by: Peter Feuerer <peter@piie.net>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
