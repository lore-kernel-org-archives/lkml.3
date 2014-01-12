Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbaALQuC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 11:50:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44297 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaALQt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 11:49:59 -0500
Message-ID: <52D2C791.2030802@zytor.com>
Date: Sun, 12 Jan 2014 08:49:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Qiaowei Ren <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86, mpx: extend siginfo structure to include bound
 violation information
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com> <1389518403-7715-5-git-send-email-qiaowei.ren@intel.com> <20140112093013.GB3664@pd.tnic>
In-Reply-To: <20140112093013.GB3664@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This thing looks like a partial duplication of functionality which we
> already have - inat.*/insn.*, etc.
> 
> It would be cleaner to integrate the mpx pieces into the existing x86
> insn analysis code and use it instead of growing your own, IMHO.
> 

I saw a previous version of the code that did that, and it really didn't
work out well -- it ended up being more complex and slower.

	-hpa

