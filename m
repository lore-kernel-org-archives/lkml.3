Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbaAWXUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 18:20:35 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35880 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaAWXUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 18:20:30 -0500
Date: Thu, 23 Jan 2014 15:20:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 00/27] 3.12.9-stable review
Message-ID: <20140123232030.GA31674@roeck-us.net>
References: <20140123190648.720195687@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 11:06:37AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.9 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat Jan 25 19:06:36 UTC 2014.
> Anything received after that time might be too late.
> 
Build test looks good:
	total: 126 pass: 121 skipped: 5 fail: 0

Note that I added several individual build tests for arm but dropped
arm:allmodconfig. Background is that arm:allmodconfig is quite notoriously
broken nowadays, and it doesn't make much sense to keep testing it.

qemu tests all passed.

Details are available at http://server.roeck-us.net:8010/builders.

Thanks,
Guenter
