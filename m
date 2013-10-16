Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620Ab3JPKtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:49:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49290 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760583Ab3JPKtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:49:19 -0400
Date: Wed, 16 Oct 2013 12:49:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        m.chehab@samsung.com
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Message-ID: <20131016104904.GD13608@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
 <20131015165435.GA2777@naverao1-tp.ibm.com>
 <20131016095030.GA8954@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131016095030.GA8954@gchen.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, I don't know what's the problem but when I hit reply-to-all to your
emails, mutt drops your email address from the To: and makes the CC:
list become the To: list. Strange.

On Wed, Oct 16, 2013 at 05:50:30AM -0400, Chen Gong wrote:
> This thread is so long. I have to say I'm lost ... Anyway, it looks
> like there are many different opnions on this last patch.

Why, I think it is fine.

The only compatibility issue I see is if we're going to share the
tracepoint with Naveen's GHES reporting stuff we were discussing a
couple of weeks ago. But AFAIR, we still needed EDAC assistance there
while here there's no need for that.

> I will send the 2nd version for further discussion soon.

Yes please. :)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
