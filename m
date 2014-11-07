Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaKGXsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:48:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57182 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbaKGXst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:48:49 -0500
Date: Sat, 8 Nov 2014 00:48:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 8/8] x86, microcode, intel: defend apply_microcode_intel
 with BUG_ON
Message-ID: <20141107234844.GH5180@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-9-git-send-email-hmh@hmh.eng.br>
 <20141107200501.GF5180@pd.tnic>
 <20141107225639.GD18128@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141107225639.GD18128@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 08:56:39PM -0200, Henrique de Moraes Holschuh wrote:
> But if you feel this is too defensive,

Yes I do.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
