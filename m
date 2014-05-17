Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaEQJ65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 05:58:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57808 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327AbaEQJ6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 05:58:55 -0400
Date: Sat, 17 May 2014 11:58:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH] x86/mce: Clear a useless global variable in mce.c
Message-ID: <20140517095838.GA23100@pd.tnic>
References: <1400316324-6280-1-git-send-email-slaoub@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400316324-6280-1-git-send-email-slaoub@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 04:45:24PM +0800, Chen Yucong wrote:
> This patch is just used to remove a useless global variable mce_entry
> and relative operations in mce.c.

Well, I can see from the diff below what you're saying here but a commit
message should contain information which explains *why* you're doing the
change and not *what* you're doing - that we can see.

IOW, you could instead do some git history research and write in your
commit message why this mce_entry got unused and quote commits which
removed it, why they removed it and why we want to remove the remains of
it now.

In any case, the change itself is correct, I would like to have a commit
message which explains why we're removing it.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
