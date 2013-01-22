Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3AVSLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:11:46 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57077 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab3AVSLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:11:44 -0500
Message-ID: <50FED605.1060100@linux.vnet.ibm.com>
Date: Tue, 22 Jan 2013 12:10:13 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv2 0/9] zswap: compressed swap caching
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012218-2398-0000-0000-0000104D69CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to include the link to the performance information we have
gathered on zswap from the first patchset.

Here are some addition performance metrics regarding the performance
improvements and I/O reductions that can be achieved using zswap as
measured by SPECjbb.

http://ibm.co/VCgHvM

These results include runs on x86 and new results on Power7+ with
hardware compression acceleration.

Thanks,
Seth

