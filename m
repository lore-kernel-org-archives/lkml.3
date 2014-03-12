Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbaCLOW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:22:57 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:38743 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaCLOWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:22:55 -0400
Date: Wed, 12 Mar 2014 15:22:48 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Christian Riesch <christian.riesch@omicron.at>
Cc: =?iso-8859-1?B?U/hyZW5zZW4s?= <Stefan.Sorensen@spectralink.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, davem@davemloft.net
Subject: Re: [PATCH RFC net-next v1 0/9] ptp: dynamic pin control
Message-ID: <20140312142248.GA10256@netboy>
References: <cover.1394307303.git.richardcochran@gmail.com>
 <1394455974.2296.22.camel@e37108.spectralink.com>
 <20140310134227.GB19781@netboy>
 <E9E8485F5E84770575AD1FAB@[172.22.2.41]>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E9E8485F5E84770575AD1FAB@[172.22.2.41]>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 07:58:37AM +0100, Christian Riesch wrote:
> >I did not change the n_per_out in this series,
> 
> Why not? I think it would be a good idea to set both n_ext_ts and
> n_per_out to the correct value right from the start (8, right?).
> Christian

Yes, it is a good idea, but it is a little extra work, especially
testing it. Channels 0 and 1 must be programmed differently, IIRC.

Right now, I am focusing on:

1. getting the new ioctl interface right
2. making it work for the phyter while keeping the module params.

After that, as I said before:
 
> >but once this basic
> >support gets merged, then you will be able to increase n_per_out for
> >the dp83640 with little extra effort.

Thanks,
Richard
