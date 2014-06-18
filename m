Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaFRPBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:01:36 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:61576 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaFRPBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:01:34 -0400
Message-ID: <53A1A9CA.7000108@gmail.com>
Date: Wed, 18 Jun 2014 10:01:30 -0500
From: Bruce Dubbs <bruce.dubbs@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120628 Firefox/13.0.1 SeaMonkey/2.10.1
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux v2.25-rc1
References: <20140618134616.GA25885@x2.net.home>
In-Reply-To: <20140618134616.GA25885@x2.net.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak wrote:
>
> The util-linux release v2.25 is available at
>
>    ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.25
>
> Feedback and bug reports, as always, are welcomed.

In an LFS build environment, the configure, make, and make check are all 
clean.  It is especially nice the way you tell us why some tests are not 
run (mostly not root permissions).

In prior releases, the last/ipv6 and last/last tests did not pass in the 
LFS environment, but they now do pass.

It would be nice if we could set the adjtime path in configure.  Right 
now we do:

sed -i -e 's@etc/adjtime@var/lib/hwclock/adjtime@g' \
           $(grep -rl '/etc/adjtime' .)

   -- Bruce

