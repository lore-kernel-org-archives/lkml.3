Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbbALPGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:06:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39991 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbbALPGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:06:06 -0500
Date: Mon, 12 Jan 2015 16:06:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac: i5100_edac: Remove unused function
Message-ID: <20150112150601.GC3904@pd.tnic>
References: <1420999030-21770-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420999030-21770-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 06:57:10PM +0100, Rickard Strandqvist wrote:
> Remove the function i5100_recmema_dm_buf_id() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
