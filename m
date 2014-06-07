Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbaFGQdx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 12:33:53 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33430 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaFGQdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 12:33:52 -0400
Date: Sat, 7 Jun 2014 09:33:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 00/92] 3.2.60-rc1 review
Message-ID: <20140607163344.GA2575@roeck-us.net>
References: <lsq.1402104388.385007124@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2014 at 02:26:28AM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.60 release.
> There are 92 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Jun 09 01:26:28 UTC 2014.
> Anything received after that time might be too late.
> 
Build restults:
	total: 133 pass: 98 skipped: 25 fail: 10

Qem tests all passed.

No unexpected build failures; results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
