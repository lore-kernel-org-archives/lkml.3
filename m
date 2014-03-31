Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaCaAuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:50:15 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45891 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaCaAuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 20:50:12 -0400
Date: Sun, 30 Mar 2014 17:49:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 000/200] 3.2.56-rc1 review
Message-ID: <20140331004857.GA10898@roeck-us.net>
References: <lsq.1396221814.369444335@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 12:23:34AM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.56 release.
> There are 200 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Apr 02 00:00:00 UTC 2014.
> Anything received after that time might be too late.
> 
Build results:
	total: 116 pass: 87 skipped: 22 fail: 7

Qemu tests all passed. Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
