Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab3LJREx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:04:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42689 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3LJREv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:04:51 -0500
Date: Tue, 10 Dec 2013 09:04:49 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 00/62] 3.12.5-stable review
Message-ID: <20131210170449.GC15940@roeck-us.net>
References: <20131210080057.415644748@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 12:00:31AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.5 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Dec 12 08:00:42 UTC 2013.
> Anything received after that time might be too late.
> 
Build results:
	total: 110 pass: 107 skipped: 3 fail: 0

qemu tests all passed.

Results are as expected.
Details are available as usual at http://server.roeck-us.net:8010/builders.

Guenter
