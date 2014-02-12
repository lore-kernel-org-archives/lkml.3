Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaBLEUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 23:20:41 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62340 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaBLEUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 23:20:40 -0500
Date: Tue, 11 Feb 2014 20:20:37 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/79] 3.10.30-stable review
Message-ID: <20140212042037.GB26490@roeck-us.net>
References: <20140211184720.928667275@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 11:05:04AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.30 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Feb 13 18:46:56 UTC 2014.
> Anything received after that time might be too late.
> 
Build results:
	total: 126 pass: 121 skipped: 4 fail: 1

qemu tests all passed.

Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
