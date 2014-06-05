Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaFERPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:15:32 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:61334 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaFERPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:15:30 -0400
Date: Thu, 5 Jun 2014 10:15:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 000/103] 3.10.42-stable review
Message-ID: <20140605171524.GB725@roeck-us.net>
References: <20140604232546.704156131@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 04:24:23PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.42 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Jun  6 23:24:52 UTC 2014.
> Anything received after that time might be too late.
> 
Build results:
	total: 143 pass: 136 skipped: 6 fail: 1

Qemu tests all passed.
Results are as expected (failing build is unicore32:defconfig).
Details are available at http://server.roeck-us.net:8010/builders.

Guenter
