Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3FFJq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:46:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51491 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab3FFJq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:46:26 -0400
Date: Thu, 6 Jun 2013 11:46:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, bp@suse.de, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac: Add code to handle new MCE signatures for new
 models of Fam15h
Message-ID: <20130606094610.GB20972@pd.tnic>
References: <1370465403-2370-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20130605213249.GD29856@pd.tnic>
 <51AFB3DC.10308@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51AFB3DC.10308@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 04:55:40PM -0500, Aravind Gopalakrishnan wrote:
> >Since "parity error" is already in the printk below, I'm guessing this
> >string should be "Retire status queue" only?
> 
>     Okay, that should convey the message too...

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
