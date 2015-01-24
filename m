Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbbAXTak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 14:30:40 -0500
Received: from rrcs-76-79-27-186.west.biz.rr.com ([76.79.27.186]:26392 "EHLO
	rrcs-76-79-27-186.west.biz.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614AbbAXTai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 14:30:38 -0500
Date: Sat, 24 Jan 2015 13:30:32 -0600
From: Jeff Epler <jepler@unpythonic.net>
To: Anshul Garg <aksgarg1989@gmail.com>
Cc: akpm@linux-foundation.org, Levente Kurusa <levex@linux.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org,
        "anshul.g@samsung.com" <anshul.g@samsung.com>
Subject: Re: [PATCH] lib/kstrtox.c clean kstrtoll function
Message-ID: <20150124193031.GG40116@unpythonic.net>
References: <aksgarg1989@gmai.com>
 <1421934850-77446-1-git-send-email-aksgarg1989@gmail.com>
 <20150122172501.GE40116@unpythonic.net>
 <CA+HOOsiP-uLJPJzn=24XiodaK89-y7Fy8oj+ALnbw4iHdtGR5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+HOOsiP-uLJPJzn=24XiodaK89-y7Fy8oj+ALnbw4iHdtGR5A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Jan 23, 2015 at 06:55:36PM +0530, Anshul Garg wrote:
> if (((long long)tmp < LLONG_MIN) || ((long long)tmp > LLONG_MAX) )
> + return -ERANGE;

This proposed code is still wrong (-ERANGE can never be returned by this
statement).  It may be best to leave the code alone, rather than propose
more untested alternatives.

Jeff
