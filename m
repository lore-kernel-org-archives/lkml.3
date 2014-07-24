Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935232AbaGXKYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:24:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60334 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758927AbaGXKYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:24:13 -0400
Date: Thu, 24 Jul 2014 12:24:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 1/8] x86, microcode, amd: fix missing static declaration
Message-ID: <20140724102409.GG19239@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-2-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406146251-8540-2-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:10:44PM -0300, Henrique de Moraes Holschuh wrote:
> gcc warns that a declaration is missing.  Fix it.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
