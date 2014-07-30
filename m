Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaG3QGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:06:10 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34245 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaG3QGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:06:07 -0400
Date: Wed, 30 Jul 2014 09:06:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/10] 3.4.101-stable review
Message-ID: <20140730160603.GA26561@roeck-us.net>
References: <20140730014807.477761030@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730014807.477761030@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 06:48:31PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.101 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Aug  1 01:47:50 UTC 2014.
> Anything received after that time might be too late.
> 
Build results:
	total: 119 pass: 113 fail: 6
Failed builds:
	alpha:allmodconfig
	arm:spear6xx_defconfig
	score:defconfig
	sparc64:allmodconfig
	unicore32:defconfig
	xtensa:allmodconfig

Qemu tests all passed.

Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
