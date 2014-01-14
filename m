Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaANTTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:19:49 -0500
Received: from mga03.intel.com ([143.182.124.21]:47815 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbaANTTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:19:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,658,1384329600"; 
   d="scan'208";a="458741464"
Message-ID: <52D58DC6.3090802@linux.intel.com>
Date: Tue, 14 Jan 2014 11:19:34 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86, kaslr] BUG: kernel boot hang
References: <20140114133125.GB26942@localhost>	<52D55F92.8040108@linux.intel.com> <CAGXu5j+eWG8h_+K9pn42u9tXWrjc6tWthNGURhd8yfM2ODeMyw@mail.gmail.com>
In-Reply-To: <CAGXu5j+eWG8h_+K9pn42u9tXWrjc6tWthNGURhd8yfM2ODeMyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 10:32 AM, Kees Cook wrote:
> 
> Not that this would change the code here, but I notice tip:x86/kaslr
> isn't fully up to date. It's still missing the two most recent
> commits:
> 
> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=kaslr-c-v8
> 
> "x86, kaslr: clarify RANDOMIZE_BASE_MAX_OFFSET"
> "x86, kaslr: remove unused including <linux/version.h>"
> 

Fixed.  The patches were tagged [PATCH -next] and so I overlooked them.

	-hpa


