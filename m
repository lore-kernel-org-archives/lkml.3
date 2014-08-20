Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaHTQzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:55:18 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41598 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaHTQzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:55:15 -0400
Date: Wed, 20 Aug 2014 09:54:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/104] 3.12.27-stable review
Message-ID: <20140820165459.GA21275@roeck-us.net>
References: <cover.1408535000.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 01:43:51PM +0200, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.27 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Aug 22 13:43:20 CEST 2014.
> Anything received after that time might be too late.
> 
Build results look good:
	total: 135 pass: 135 fail: 0

qemu tests passed except for sparc64 which hangs during boot, both for SMP and
non-SMP builds. I'll try to bisect as soon as I have a somewhat stable internet
connection.

Guenter
