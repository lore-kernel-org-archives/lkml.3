Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaKKQIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:08:55 -0500
Received: from skprod2.natinst.com ([130.164.80.23]:51782 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751164AbaKKQIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:08:54 -0500
Date: Tue, 11 Nov 2014 10:08:10 -0600
From: Ben Shelton <ben.shelton@ni.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH 4/4] UBIFS: add ubifs_err() to print error reason
Message-ID: <20141111160809.GA11589@bshelton-desktop>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
 <1414781431-2911-5-git-send-email-ben.shelton@ni.com>
 <1415704235.22887.138.camel@sauron.fi.intel.com>
MIME-Version: 1.0
In-Reply-To: <1415704235.22887.138.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 11/11/2014 10:08:21 AM,
	Serialize by Router on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 11/11/2014 10:08:21 AM,
	Serialize complete at 11/11/2014 10:08:21 AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-11_03:2014-11-11,2014-11-11,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Artem Bityutskiy wrote:
> Pushed this, but made some amendments.
> 
> Now all 4 are in the master branch. Would you please re-test them again
> and confirm that they are fine. Then I'll push them to the linux-next
> branch, unless you report that my amendments broke something.
> 
> Thank you!
> 

Hi Artem,

I pulled the four modified commits into my 3.18-rc3 branch and tested
with lockdep enabled.  Everything looks good.

Thanks,
Ben

