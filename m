Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaBGIIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:08:44 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:1606 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaBGIIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:08:43 -0500
X-IronPort-AV: E=Sophos;i="4.95,799,1384300800"; 
   d="scan'208";a="98903905"
Message-ID: <52F49489.6080706@citrix.com>
Date: Fri, 7 Feb 2014 09:08:41 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matt Wilson <msw@linux.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad@darnok.org>, <mrushton@amazon.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <msw@amazon.com>
Subject: Re: [Xen-devel] [PATCH v2 0/4] xen-blk: bug fixes
References: <1391509575-3949-1-git-send-email-roger.pau@citrix.com> <20140204151501.GA1781@andromeda.dapyr.net> <20140206045729.GA15901@u109add4315675089e695.ant.amazon.com> <20140206162004.GA22864@konrad-lan.dumpdata.com> <20140207042427.GA28057@u109add4315675089e695.ant.amazon.com>
In-Reply-To: <20140207042427.GA28057@u109add4315675089e695.ant.amazon.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/14 05:24, Matt Wilson wrote:
> Just in case the various mailing list software ate Matt's messages, he
> sent the following:
> 
> [PATCH v2 2/4] xen-blkback: fix memory leaks
> Tested-by: Matt Rushton <mrushton@amazon.com>
> Reviewed-by: Matt Rushton <mrushton@amazon.com>
> 
> [PATCH v2 3/4] xen-blkback: fix shutdown race
> Tested-by: Matt Rushton <mrushton@amazon.com>
> Reviewed-by: Matt Rushton <mrushton@amazon.com>
> 
> [PATCH v2 4/4] xen-blkif: drop struct blkif_request_segment_aligned
> Tested-by: Matt Rushton <mrushton@amazon.com>
> 
> I've separately sent suggestions to Matt on how to setup his mailer to
> format messages per list etiquette and how to avoid breaking message
> threading.

Thanks for the review and testing!

Roger.

