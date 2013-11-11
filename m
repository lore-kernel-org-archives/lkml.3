Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab3KKTru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:47:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45342 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3KKTro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:47:44 -0500
Date: Mon, 11 Nov 2013 20:47:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        amd64-microcode@amd64.org
Subject: Re: [PATCH v2 1/3] firmware: Introduce request_firmware_direct()
Message-ID: <20131111194721.GG28219@pd.tnic>
References: <1384183278-19787-1-git-send-email-tiwai@suse.de>
 <1384183278-19787-2-git-send-email-tiwai@suse.de>
 <20131111153426.GA6630@pd.tnic>
 <s5heh6mx2vz.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s5heh6mx2vz.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 06:30:08PM +0100, Takashi Iwai wrote:
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] firmware: Use bit flags instead of boolean combos
> 
> More than two boolean arguments to a function are rather confusing and
> error-prone for callers.  Let's make the behavior bit flags instead of
> triple combos.
> 
> A nice suggestion by Borislav Petkov.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/base/firmware_class.c | 49 ++++++++++++++++++++++++-------------------
>  1 file changed, 28 insertions(+), 21 deletions(-)

Yeah, looks good, thanks!

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
