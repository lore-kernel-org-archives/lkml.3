Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3KBCb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 22:31:29 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:63095 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3KBCb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 22:31:27 -0400
Date: Fri, 1 Nov 2013 19:31:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.11 00/66] 3.11.7-stable review
Message-ID: <20131102023126.GC20224@roeck-us.net>
References: <20131101220634.605745564@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 03:06:36PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.11.7 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun Nov  3 22:04:49 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.7-rc1.gz
> and the diffstat can be found below.
> 
Build results look good:
        total: 110 pass: 108 skipped: 2 fail: 0

qemu tests all pass.

Details are at http://server.roeck-us.net:8010/builders.

Guenter
