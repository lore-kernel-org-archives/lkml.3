Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab3KIRAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 12:00:34 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42837 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3KIRAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 12:00:30 -0500
Date: Sat, 9 Nov 2013 09:00:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.11 00/94] 3.11.8-stable review
Message-ID: <20131109170028.GA14421@roeck-us.net>
References: <20131109065204.252462489@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 10:51:06PM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.11.8 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Nov 11 06:51:44 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.8-rc1.gz
> and the diffstat can be found below.
> 

Build test results look good:
	total: 110 pass: 108 skipped: 2 fail: 0

qemu tests all pass.

Thanks,
Guenter
