Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3JKV43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:56:29 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59881 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3JKV40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 17:56:26 -0400
Date: Fri, 11 Oct 2013 14:56:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/48] 3.4.66-stable review
Message-ID: <20131011215619.GB9941@roeck-us.net>
References: <20131011193637.253208688@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 12:36:07PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.66 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun Oct 13 19:35:35 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.66-rc1.gz
> and the diffstat can be found below.
> 
Less than perfect test results:
	total: 103 pass: 83 skipped: 10 fail: 10

New failures appear to be due to:
	'powerpc: Restore registers on error exit from csum_partial_copy_generic()'.
which causes six of the powerpc builds to fail.

qemu tests all pass.

Guenter
