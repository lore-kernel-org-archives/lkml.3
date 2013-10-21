Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3JUP0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 11:26:05 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51885 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3JUP0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 11:26:03 -0400
Date: Mon, 21 Oct 2013 08:25:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 000/149] 3.2.52-rc1 review
Message-ID: <20131021152554.GA18317@roeck-us.net>
References: <lsq.1382345187.199780875@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 09:46:27AM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.52 release.
> There are 149 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Oct 25 08:00:00 UTC 2013.
> Anything received after that time might be too late.
> 
> A combined patch relative to 3.2.51 will be posted as an additional
> response to this.  A shortlog and diffstat can be found below.
> 
Build results look good:
	total: 100 pass: 78 skipped: 14 fail: 8

which is four less failures than with 3.2.51 (m68k-nommu builds now all pass).

qemu build and load tests all pass.

Guenter
