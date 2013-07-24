Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab3GXRP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:15:59 -0400
Received: from 1wt.eu ([62.212.114.60]:33408 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab3GXRP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:15:57 -0400
Date: Wed, 24 Jul 2013 19:15:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "gregkh@linuxfoundation.org >> Kroah-Hartman, Greg" 
	<gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [ 000/103] 3.10.3-stable review
Message-ID: <20130724171547.GG26628@1wt.eu>
References: <20130723220418.532514378@linuxfoundation.org> <CAKocOOPO61YUj5kTL7k1HuEeDdB_x=sxWga007nBSiLD4Px5Mg@mail.gmail.com> <B8EFE96D1287C24090BAD9D858E15E61748BEA@sisaex01sj> <20130724145506.GC15095@kroah.com> <CA+55aFxdz6X8BfdzM5CwH_5Jmz=R1JMuLoo=r1yhWST+tKA7bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxdz6X8BfdzM5CwH_5Jmz=R1JMuLoo=r1yhWST+tKA7bw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:04:17AM -0700, Linus Torvalds wrote:
> The alternative workflow is to tell git to track the new files added
> by the patch. So if you use "git apply --index", git will not just
> apply the patch, it will also add the result to the index - so you
> could commit it with a single "git commit", and you can see the diff -
> including new files - with "git diff --cached". And then "git reset
> --hard" will also undo the new files.

When I test Greg's pre-releases, I tend to apply the whole mail thread
using "git am". After that I just have to manually updated the Makefile
and that's fine. When I try the merged -rc patch insted, I also use
"git apply --index" which I find convenient for this.

Willy

