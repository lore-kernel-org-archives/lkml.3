Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaFERUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:20:38 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52270 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaFERUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:20:36 -0400
Date: Thu, 5 Jun 2014 10:20:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/228] 3.14.6-stable review
Message-ID: <20140605172030.GC725@roeck-us.net>
References: <20140604232347.966798903@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 04:20:29PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.6 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Jun  6 23:23:11 UTC 2014.
> Anything received after that time might be too late.
> 
Build results:
	total: 143 pass: 136 skipped: 4 fail: 3

Qemu tests all passed.

Failing builds are:
	powerpc:allmodconfig with binutils 2.23
	powerpc:allmodconfig with binutils 2.24
	unicore32:defconfig

Results are as expected.
Details are available at http://server.roeck-us.net:8010/builders.

I'll check with Ben if his fix for the powerpc build problem is going
to make it upstream; I have not seen it applied yet.

Guenter
