Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3A3Dqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:46:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49624 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab3A3Dq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:46:28 -0500
Date: Wed, 30 Jan 2013 04:46:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, Jacob.Shin@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] AMD,x86: Clean up init_amd()
Message-ID: <20130130034625.GD30965@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@amd.com>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, Jacob.Shin@amd.com,
	linux-kernel@vger.kernel.org
References: <1359497676-24722-1-git-send-email-boris.ostrovsky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359497676-24722-1-git-send-email-boris.ostrovsky@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 05:14:36PM -0500, Boris Ostrovsky wrote:
> Clean up multiple declarations of variable used for rd/wrmsr
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
