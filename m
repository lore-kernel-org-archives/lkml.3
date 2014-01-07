Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaAGPML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:12:11 -0500
Received: from 8bytes.org ([85.214.48.195]:36327 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaAGPMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:12:06 -0500
Date: Tue, 7 Jan 2014 16:12:00 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: akpm@linux-foundation.org, alexander.h.duyck@intel.com,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH v2] dma-debug: enhance dma_debug_device_change() to check
 for mapping errors
Message-ID: <20140107151200.GA29041@8bytes.org>
References: <1384376168-2148-1-git-send-email-shuah.kh@samsung.com>
 <20131230141511.GC2799@8bytes.org>
 <52C700BC.1010200@samsung.com>
 <20140107142625.GC2742@8bytes.org>
 <52CC1691.9040603@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CC1691.9040603@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jan  7 16:12:01 2014
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52cc194120865727254301
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 08:00:33AM -0700, Shuah Khan wrote:
> This patch and a follow-on cocinelli warning fix patch are in
> linux-next. Would you like me to send a patch relative to the change
> in linux-next or cut a new patch against the latest Linus's git. I
> can go either way. We just have to remember to drop those two
> patches from linux-next.

Please do a patch against linus.git and drop the two patches from
linux-next. Over which tree did they go into linux-next anyway?


	Joerg


