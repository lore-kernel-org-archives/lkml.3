Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3KSDLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:11:21 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54495 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3KSDLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:11:19 -0500
Date: Mon, 18 Nov 2013 19:11:17 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 00/19] 3.12.1-stable review
Message-ID: <20131119031117.GC16010@roeck-us.net>
References: <20131118183644.030738675@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118183644.030738675@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:37:13AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.1 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Nov 20 18:36:14 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.1-rc1.gz
> and the diffstat can be found below.
> 
Build test results:
	total: 110 pass: 107 skipped: 3 fail: 0

qemu tests all passed.

Results match those seen with the previous release and are as expected.

Guenter
