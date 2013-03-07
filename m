Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab3CGLJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:09:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40305 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235Ab3CGLJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:09:15 -0500
Date: Thu, 7 Mar 2013 12:09:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] buildtar: Add ARCH to the archive name
Message-ID: <20130307110910.GA5834@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joerg Roedel <joro@8bytes.org>, Michal Marek <mmarek@suse.cz>,
	linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Borislav Petkov <bp@suse.de>
References: <1362557147-14393-1-git-send-email-bp@alien8.de>
 <20130307110659.GC22602@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130307110659.GC22602@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 12:06:59PM +0100, Joerg Roedel wrote:
> Good idea, but I already hear people yelling about their scripts that
> break with this change :)

They better fix them then. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
