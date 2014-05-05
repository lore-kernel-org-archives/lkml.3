Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaEEIr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:47:28 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:37229 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbaEEIrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:47:25 -0400
Date: Mon, 5 May 2014 16:47:17 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH] drivercore: fix a corner case for deferred probe
Message-ID: <20140505084717.GA5712@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1398045202-5714-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <20140505022805.GA15162@richard>
 <20140505030432.GA11957@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505030432.GA11957@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050508-5816-0000-0000-00000DD751C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 08:04:32PM -0700, Greg KH wrote:
>On Mon, May 05, 2014 at 10:28:05AM +0800, Wei Yang wrote:
>> Hi, all
>> 
>> Anyone has some comment on this?
>
>Did you miss the patch from Grant that is now in Linus's tree that
>should resolve this issue?

Hi, Greg,

Nice to hear from you.

Would you mind telling me the exact tree and commit? I searched in the
git.kernel.org, and see several Linus's tree, including Linus Torvalds and
Linus Walleij. So, not sure which you are pointing to. With the exact commit
and tree, I could take a more deep look into it :-)


BTW, I am using this tree:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
based on commit "455c6fd Linux 3.14".

>
>thanks,
>
>greg k-h

-- 
Richard Yang
Help you, Help me

