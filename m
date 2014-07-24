Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbaGXKdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:33:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56640 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032AbaGXKdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:33:41 -0400
Date: Thu, 24 Jul 2014 12:33:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 3/8] x86, microcode, intel: fix typos
Message-ID: <20140724103337.GI19239@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-4-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406146251-8540-4-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:10:46PM -0300, Henrique de Moraes Holschuh wrote:
> Fix some typos.  One of them was in a struct name, fortunately harmless
> because it happened on a "sizeof(struct foo*)" construction.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Damn, that's three different, *wrong*, spellings of "microcode" in one
single file! My favourite one is "mirocode".

:-)

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
