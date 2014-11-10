Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaKJVhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:37:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37847 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaKJVhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:37:33 -0500
Date: Mon, 10 Nov 2014 22:37:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, ak@linux.intel.com, aravind.gopalakrishnan@amd.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] x86, mce: support memory error recovery for both
 UCNA and Deferred error in machine_check_poll
Message-ID: <20141110213728.GN4359@pd.tnic>
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
 <1415410821-15063-3-git-send-email-slaoub@gmail.com>
 <20141110190617.GJ4359@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141110190617.GJ4359@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 08:06:17PM +0100, Borislav Petkov wrote:
> Before you go and "fix" this again, wait for me to clear up something
> else before you even go do that. I'll let you know.

Infact, you could redo this patch in the meantime without the AMD vendor
check so that Tony can pick them up soon. I'll add the correct AMD bits
later.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
