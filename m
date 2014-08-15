Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaHOPlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:41:52 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:55504 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaHOPlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:41:50 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Aug 2014 11:41:50 EDT
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Fri, 15 Aug 2014 11:33:53 -0400
To: Brian Norris <computersforpeace@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: Overriding -Werror
Message-ID: <20140815153353.GG17769@csclub.uwaterloo.ca>
References: <20140814222119.GD18411@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140814222119.GD18411@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 03:21:19PM -0700, Brian Norris wrote:
> I'm interested in being able to build-test kernels on various
> architectures while enabling extra warnings (make W=[123]). I'd like to
> be able to finish the builds and see all warnings, rather than seeing a
> failed build. However, GCC's -Werror is incompatible with this. There is
> plenty of code that will produce at least one warning, when warning
> verbosity is turned up. And GCC's -Werror is not guaranteed to remain
> stable over time; new versions may develop new warnings that may or may
> not be legitimate.

What ever is wrong with using '-k' with your make command?

-- 
Len Sorensen
