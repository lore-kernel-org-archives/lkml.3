Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3HPLiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 07:38:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab3HPLij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 07:38:39 -0400
Date: Fri, 16 Aug 2013 12:38:29 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Alasdair Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        sparclinux@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] dm cache: Avoid conflicting remove_mapping() in mq
	policy
Message-ID: <20130816113829.GM1762@agk-dp.fab.redhat.com>
Mail-Followup-To: Guenter Roeck <linux@roeck-us.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Alasdair Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	sparclinux@vger.kernel.org, linux-hexagon@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1374825451-30463-1-git-send-email-geert@linux-m68k.org> <520DE356.9060506@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520DE356.9060506@roeck-us.net>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 01:31:18AM -0700, Guenter Roeck wrote:
> Is this patch going anyhere ? The problem breaks the sparc32:allmodconfig build,
> so it would be useful to get it fixed.

We're pulling together a batch of patches today, including this one.

Alasdair

