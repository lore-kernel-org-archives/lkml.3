Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3KBC3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 22:29:12 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:56266 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3KBC3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 22:29:08 -0400
Date: Fri, 1 Nov 2013 19:28:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/32] 3.4.68-stable review
Message-ID: <20131102022854.GA20224@roeck-us.net>
References: <20131101214313.735463599@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101214313.735463599@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 02:43:11PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.68 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun Nov  3 21:41:40 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.68-rc1.gz
> and the diffstat can be found below.
> 
Looks like PATCH in the headline got lost.

Test results look good:
	total: 103 pass: 89 skipped: 10 fail: 4

qemu tests all pass. 

The result matches results seen with the previous release.

Details are at http://server.roeck-us.net:8010/builders.

Thanks,
Guenter
