Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaI2LsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:48:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41499 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbaI2LsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:48:20 -0400
Date: Mon, 29 Sep 2014 13:48:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, MCE, AMD: use macros to compute bank MSRs
Message-ID: <20140929114817.GA6495@pd.tnic>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:16:01AM +0800, Chen Yucong wrote:
> Avoid open coded calculations for bank MSRs by hiding the index
> of higher bank MSRs in well-defined macros.
> 
> No semantic changes.
> 
> Signed-off-by: Chen Yucong <slaoub@gmail.com>

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
