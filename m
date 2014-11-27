Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaK0QOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:14:16 -0500
Received: from 1wt.eu ([62.212.114.60]:11288 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaK0QON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:14:13 -0500
Date: Thu, 27 Nov 2014 17:14:06 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mariusz Gorski <marius.gorski@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/9] staging: panel: Use defined value or checking module params state
Message-ID: <20141127161406.GB23012@1wt.eu>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com> <1416429531-11088-5-git-send-email-marius.gorski@gmail.com> <20141126215801.GA32756@kroah.com> <20141127132657.GA12298@firebird> <20141127152417.GB23247@kroah.com> <20141127155706.GB24149@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127155706.GB24149@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 07:57:06AM -0800, Greg Kroah-Hartman wrote:
> And the reason I got confused was because you didn't label your second
> set of patches "v2", which it was, I saw two separate series, one with a
> few patches, and then 2 sets of 9, the second set labeled "v2" so I
> thought they were independant.  Please think of the poor maintainer who
> has to decipher things like this when you send them out...

For Mariusz's defense, this was his first batch. He didn't feel comfortable
and asked me how to proceed when sending a series and I forgot to warn him
about the "v2" as initially I didn't think there would be a v2, and after I
obviously forgot I didn't speak about that. So I share some responsibility
for this one.

Mariusz, if you need some help, tell me so.

Regards,
Willy

