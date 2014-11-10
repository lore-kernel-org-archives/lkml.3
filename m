Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaKJQmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:42:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39723 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbaKJQm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:42:26 -0500
Date: Mon, 10 Nov 2014 17:42:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: tony.luck@intel.com
Cc: Chen Yucong <slaoub@gmail.com>, ak@linux.intel.com,
        aravind.gopalakrishnan@amd.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2]RAS: add the support for handling UCNA/DEFERRED
 error
Message-ID: <20141110164223.GG4359@pd.tnic>
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 09:40:19AM +0800, Chen Yucong wrote:
> Hi all,
> 
> At the suggestion of Boris, the first patch extends the mce_severity
> mechanism for handling UCNA/DEFERRED error.
>   Link: https://lkml.org/lkml/2014/10/23/190
> 
> v2:
> The first patch have also eliminated a big hack to make mce_severity() 
> work when called from non-exception context on the advice of Tony and 
> Boris.
>   Link: https://lkml.org/lkml/2014/10/27/1017
> 
> And on the basis of the first patch, the second patch adds the support
> for identifying and handling UCNA/DEFERRED error in machine_check_poll.
> 
> V3:
> According to Boris, the second patch have also split `memory_error' 
> from mem_deferred_error so that the memory_error() function can be used
> in other code paths separately. 
>   Link: https://lkml.org/lkml/2014/11/6/452
> 
> Boris also reported the warning about "MCI_STATUS_POISON" and  "MCI_STATUS_POISON"
> redefined.

Looks ok to me.

Tony, let me know if I should pick them up or you want to. Btw, there's
already tip/x86/ras for 3.19.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
