Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbaG3QJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:09:36 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59380 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaG3QJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:09:35 -0400
Date: Wed, 30 Jul 2014 09:09:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/37] 3.15.8-stable review
Message-ID: <20140730160931.GD26561@roeck-us.net>
References: <20140730014827.565626091@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 06:48:36PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.15.8 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Aug  1 01:48:13 UTC 2014.
> Anything received after that time might be too late.
> 
Build results:
	total: 141 pass: 141 fail: 0

Qemu tests all passed.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
