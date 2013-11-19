Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab3KSDHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:07:34 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41574 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3KSDHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:07:31 -0500
Date: Mon, 18 Nov 2013 19:07:29 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/12] 3.4.70-stable review
Message-ID: <20131119030729.GA15985@roeck-us.net>
References: <20131118184130.257996039@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118184130.257996039@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:41:33AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.70 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Nov 20 18:41:11 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.70-rc1.gz
> and the diffstat can be found below.
> 

Build test results:
	total: 103 pass: 89 skipped: 10 fail: 4

qemu tests all pass.

Results match the results seen with the previous release and are as expected.

Guenter
