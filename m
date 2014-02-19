Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaBSE32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 23:29:28 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48431 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaBSE31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 23:29:27 -0500
Date: Tue, 18 Feb 2014 20:29:10 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 00/32] 3.12.12-stable review
Message-ID: <20140219042910.GA15332@roeck-us.net>
References: <20140218224500.101465031@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218224500.101465031@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 02:47:00PM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.12 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Feb 20 22:44:47 UTC 2014.
> Anything received after that time might be too late.
> 

Build results:
    total: 126 pass: 121 skipped: 5 fail: 0

qemu tests all passed.

Details are available at http://server.roeck-us.net:8010/builders.

Results are as expected.

Guenter
