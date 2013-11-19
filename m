Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3KSDIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:08:35 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36990 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3KSDId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:08:33 -0500
Date: Mon, 18 Nov 2013 19:08:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/24] 3.10.20-stable review
Message-ID: <20131119030831.GA16010@roeck-us.net>
References: <20131118184222.017393843@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118184222.017393843@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:42:10AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.20 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Nov 20 18:42:04 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.20-rc1.gz
> and the diffstat can be found below.
> 

Build test results:
        total: 110 pass: 110 skipped: 0 fail: 0

qemu tests all pass.

Results match the results seen with the previous release and are as expected.

Guenter
