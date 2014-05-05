Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaEEPph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:45:37 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50566 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaEEPpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:45:35 -0400
Date: Mon, 5 May 2014 08:45:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 00/50] 3.12.19-stable review
Message-ID: <20140505154527.GA25094@roeck-us.net>
References: <cover.1399292849.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 02:28:31PM +0200, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.19 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed May  7 12:27:29 2014
> Anything received after that time might be too late.
> 
Build results:
	total: 127 pass: 121 skipped: 5 fail: 1

qemu tests all passed.

The build failure is for unicore32:defconfig, which fails to build
on all releases I tried. Results are therefore as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
