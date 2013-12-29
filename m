Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab3L2Nyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 08:54:54 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39893 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3L2Nyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 08:54:52 -0500
Date: Sun, 29 Dec 2013 05:54:49 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 000/185] 3.2.54-rc1 review
Message-ID: <20131229135449.GA25007@roeck-us.net>
References: <lsq.1388282923.751256928@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 03:08:43AM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.54 release.
> There are 185 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Jan  1 00:00:00 UTC 2014.
> Anything received after that time might be too late.
> 
> A combined patch relative to 3.2.53 will be posted as an additional
> response to this.  A shortlog and diffstat can be found below.
> 
Build results:
	total: 100 pass: 78 skipped: 14 fail: 8

qemu tests all pass.

Results are as expected.

Guenter
