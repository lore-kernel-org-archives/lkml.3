Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaJAQXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:23:39 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40320 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaJAQXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:23:37 -0400
Date: Wed, 1 Oct 2014 09:23:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 00/96] 3.12.30-stable review
Message-ID: <20141001162332.GB11708@roeck-us.net>
References: <cover.1412147522.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1412147522.git.jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:57:39AM +0200, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.30 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> This one is special. First, it is rounded (30). Second, most of the
> patches are performance improvements. They are coming from SUSE
> Enterprise Linux and all are backed by proper testing and performance
> measurements. All this patchset was prepared and sent by Mel Gorman
> with a support of other patchers from SUSE. Thanks to all of them.
> 
> As this is special, I am gicing a whole week for responses. So
> responses should be made by Wed Oct  8 09:12:02 CEST 2014.  Anything
> received after that time might be too late.
> 
Build results:
	total: 135 pass: 135 fail: 0
Qemu test results:
	total: 23 pass: 23 fail: 0

Guenter
