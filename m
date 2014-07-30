Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaG3QHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:07:25 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36142 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbaG3QHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:07:20 -0400
Date: Wed, 30 Jul 2014 09:07:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/21] 3.10.51-stable review
Message-ID: <20140730160717.GB26561@roeck-us.net>
References: <20140730014830.424826215@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730014830.424826215@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 06:48:29PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.51 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Aug  1 01:48:18 UTC 2014.
> Anything received after that time might be too late.
> 
Build results:
	total: 140 pass: 140 fail: 0

Qemu tests all passed.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
