Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab3GXRQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:16:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3GXRQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:16:16 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=X7p0W-CcHCoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=mHU5uDWqTv3_3SalE-0A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374686174.3356.135.camel@gandalf.local.home>
Subject: Re: [ 000/103] 3.10.3-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "gregkh@linuxfoundation.org >> Kroah-Hartman, Greg" 
	<gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Wed, 24 Jul 2013 13:16:14 -0400
In-Reply-To: <CA+55aFxdz6X8BfdzM5CwH_5Jmz=R1JMuLoo=r1yhWST+tKA7bw@mail.gmail.com>
References: <20130723220418.532514378@linuxfoundation.org>
	 <CAKocOOPO61YUj5kTL7k1HuEeDdB_x=sxWga007nBSiLD4Px5Mg@mail.gmail.com>
	 <B8EFE96D1287C24090BAD9D858E15E61748BEA@sisaex01sj>
	 <20130724145506.GC15095@kroah.com>
	 <CA+55aFxdz6X8BfdzM5CwH_5Jmz=R1JMuLoo=r1yhWST+tKA7bw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 10:04 -0700, Linus Torvalds wrote:

> The alternative workflow is to tell git to track the new files added
> by the patch. So if you use "git apply --index", git will not just
> apply the patch, it will also add the result to the index - so you
> could commit it with a single "git commit", and you can see the diff -
> including new files - with "git diff --cached". And then "git reset
> --hard" will also undo the new files.

I don't know why "git apply" doesn't do it by default. Why would you
want to apply a patch without having git track new files?

This burnt me a few times when working with the -rt patch until I found
to use "--index" always.

-- Steve


