Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3COT0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:26:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48049 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab3COT0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:26:17 -0400
Date: Fri, 15 Mar 2013 20:26:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: chegger@amazon.de, xen-devel@lists.xen.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 0/2] AMD MCE fixes
Message-ID: <20130315192609.GJ13775@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, chegger@amazon.de,
	xen-devel@lists.xen.org, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org, JBeulich@suse.com,
	stable@vger.kernel.org
References: <1363295441-1859-1-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1363295441-1859-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 05:10:39PM -0400, Boris Ostrovsky wrote:
> 
> Boris,
> 
> Here is the updated patch for determining number of regiter banks on
> AMD plus a patch removing shared_bank array, as you suggested.
> 
> Offline/online testing didn't show any issues.
> 
> 
> 
> Boris Ostrovsky (2):
>   x86/mce: Replace shared_bank array with is_shared_bank() helper
>   x86/mce: Use MCG_CAP MSR to find out number of banks on AMD

Both applied,

thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
