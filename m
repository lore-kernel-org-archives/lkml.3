Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaCJOFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:05:19 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48271 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbaCJOFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:05:16 -0400
Date: Mon, 10 Mar 2014 15:05:11 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: =?iso-8859-1?B?U/hyZW5zZW4s?= Stefan 
	<Stefan.Sorensen@spectralink.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhutchings@solarflare.com" <bhutchings@solarflare.com>,
        "christian.riesch@omicron.at" <christian.riesch@omicron.at>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v1 0/9] ptp: dynamic pin control
Message-ID: <20140310140511.GD19781@netboy>
References: <cover.1394307303.git.richardcochran@gmail.com>
 <1394455974.2296.22.camel@e37108.spectralink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394455974.2296.22.camel@e37108.spectralink.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 12:52:57PM +0000, Sørensen, Stefan wrote:
> The implementation is limited to a single function for each pin - the
> dp83640 supports an ext_ts and several periodic outputs on the same pin,
> but I do not see that many real-world uses. 

So the main use case is to allow users to configure the auxiliary
functions according to their needs. This series provides this without
relying on DT, ACPI, etc. The sysfs control lets you put this into a
boot script, for example.

In addition, there are also less common use cases for re-configuring
pins at run time. One use would be to switch from a PPS output to a
time stamping input during automated PTP testing.

Thanks,
Richard
