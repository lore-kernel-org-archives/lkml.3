Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbaDKLsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 07:48:09 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:55757 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbaDKLsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 07:48:06 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140411103507.GK16119@n2100.arm.linux.org.uk>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<1397211951-20549-4-git-send-email-miklos@szeredi.hu>
	<20140411103507.GK16119@n2100.arm.linux.org.uk>
Date: Fri, 11 Apr 2014 13:48:05 +0200
Message-ID: <CAJfpegsbS8M4L7jKUfgw88wWnt7NYtSe5LHTsVF_oTL94xm=Fw@mail.gmail.com>
Subject: Re: [PATCH 03/15] arm: add renameat2 syscall
From: Miklos Szeredi <miklos@szeredi.hu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 12:35 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Apr 11, 2014 at 12:25:39PM +0200, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>> Cc: Russell King <linux@arm.linux.org.uk>
>
> Same comments for the previous patch.  What is/where is the remainder of
> the series, or at least the cover message to explain what the series is
> about (which may also show why the other patches are not relevant to
> everyone.)

All the series went to linux-arch, with the relevant parts CC-d to
each architecture's maintainer.

It would probably have been a good idea to CC all maintainers on the
cover letter, but I don't know how I could do that with "git
send-email".

Thanks,
Miklos
