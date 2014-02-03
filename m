Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaBCJfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:35:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58747 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaBCJfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:35:03 -0500
Date: Mon, 3 Feb 2014 10:34:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: bp@suse.de, m.chehab@samsung.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac/85xx: Remove deprecated IRQF_DISABLED
Message-ID: <20140203093458.GA22608@pd.tnic>
References: <1390293747-11185-1-git-send-email-johannes.thumshirn@men.de>
 <20140203070404.GA32443@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140203070404.GA32443@jtlinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 08:04:06AM +0100, Johannes Thumshirn wrote:
> Boris, Mauro:
> 
> Ping?

No worries, I saw your patch. But in the future, please hold off from
sending any patches during the merge window unless it is a serious
regression to code already upstream.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
