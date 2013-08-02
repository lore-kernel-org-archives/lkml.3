Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3HBR47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:56:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10797 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3HBR46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:56:58 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=ITrV3YZTT6UA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=DvBrZMNk9YcA:10 a=07d9gI8wAAAA:8 a=TSbVqHtbAAAA:8 a=hmhbshSuQ2qLY6JiOGEA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375466216.22073.6.camel@gandalf.local.home>
Subject: Re: [PATCH 1/3] dmatest: make module parameters writable
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        "Blin, Jerome" <jerome.blin@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 02 Aug 2013 13:56:56 -0400
In-Reply-To: <CE2134A4.1D1FD%djbw@fb.com>
References: <CE2134A4.1D1FD%djbw@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 17:49 +0000, Dan Williams wrote:

> However, unless I missed it, I don¹t see this support[1] upstream yet.
> 
> 
> --
> Dan
> 
> [1]: https://lwn.net/Articles/432186/

IIRC, there was some push back from doing this. I don't really remember
who? Rusty maybe?

Or maybe not, it seems he had some comments on it in that thread:

http://thread.gmane.org/gmane.linux.kernel/1110481

Perhaps I got busy and dropped it :-/

Anyway, if there's a demand for it, we can always revisit the idea.

-- Steve


