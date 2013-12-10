Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3LJRBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:01:15 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41715 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3LJRBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:01:12 -0500
Date: Tue, 10 Dec 2013 09:01:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/25] 3.4.74-stable review
Message-ID: <20131210170109.GA15940@roeck-us.net>
References: <20131210075930.808460227@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210075930.808460227@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 12:00:08AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.74 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Dec 12 07:59:15 UTC 2013.
> Anything received after that time might be too late.
> 
Build results:
	total: 103 pass: 89 skipped: 10 fail: 4

qemu tests all passed.

Results are as expected.
Details are available as usual at http://server.roeck-us.net:8010/builders.

Guenter
