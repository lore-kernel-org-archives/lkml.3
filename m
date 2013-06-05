Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab3FEWSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:18:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33171 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757679Ab3FEWSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:18:48 -0400
Date: Thu, 6 Jun 2013 00:18:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <herrmann.der.user@googlemail.com>
Subject: Re: [PATCH 0/2] x86/microcode/amd: early loading fixes
Message-ID: <20130605221833.GA15427@pd.tnic>
References: <1370463236-2115-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1370463236-2115-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 03:13:54PM -0500, Jacob Shin wrote:
> This patchset addreses two problems with early loading on AMD.

It would be nice if, in the future, you put the maintainers of this
driver to CC.

Unless you're volunteering up for maintaining it...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
