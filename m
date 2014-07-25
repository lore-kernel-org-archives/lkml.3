Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbaGYQfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:35:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51999 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbaGYQfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:35:22 -0400
Date: Fri, 25 Jul 2014 18:23:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH v2 4/8] x86, microcode, intel: rename apply_microcode and
 declare it static
Message-ID: <20140725162333.GD4421@pd.tnic>
References: <1406146251-8540-5-git-send-email-hmh@hmh.eng.br>
 <1406226201-18820-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406226201-18820-1-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 03:23:21PM -0300, Henrique de Moraes Holschuh wrote:
> Rename apply_microcode() in microcode/intel.c to apply_microcode_intel(),
> and declare it as static.
> 
> This is a cosmetic fix to silence a warning issued by sparse.  It brings
> the microcode/intel.c driver in line with what microcode/amd.c is doing.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> ---
>  v2: declare as static instead of extern, and changed patch title

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
