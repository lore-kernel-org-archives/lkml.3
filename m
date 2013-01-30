Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3A3Dwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:52:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53548 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab3A3Dwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:52:37 -0500
Date: Wed, 30 Jan 2013 04:52:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, Jacob.Shin@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86,AMD: Enable WC+ memory type on family 10
 processors
Message-ID: <20130130035235.GE30965@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@amd.com>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, Jacob.Shin@amd.com,
	linux-kernel@vger.kernel.org
References: <1359497723-24791-1-git-send-email-boris.ostrovsky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359497723-24791-1-git-send-email-boris.ostrovsky@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 05:15:23PM -0500, Boris Ostrovsky wrote:
> In some cases BIOS may not enable WC+ memory type on family 10
> processors, instead converting what would be WC+ memory to CD type.
> On guests using nested pages this could result in performance
> degradation. This patch enables WC+.
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
