Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaATR2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:28:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:19521 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaATR2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:28:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,691,1384329600"; 
   d="scan'208";a="467844540"
Message-ID: <52DD5CC4.3010708@linux.intel.com>
Date: Mon, 20 Jan 2014 19:28:36 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: linux-man@vger.kernel.org, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v2] socket.7: add description for SO_BUSY_POLL
References: <20130710141835.15799.61657.stgit@ladj378.jer.intel.com> <52DD4EC6.7080208@gmail.com>
In-Reply-To: <52DD4EC6.7080208@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/2014 18:28, Michael Kerrisk (man-pages) wrote:
> On 07/10/2013 04:18 PM, Eliezer Tamir wrote:
>> Add description for the SO_BUSY_POLL socket option to the socket(7) manpage.
> 
> Long after the fact, I've applied this. Thanks, Eliezer.
> 
> Would you be willing also to write a patch for the POLL_BUSY_LOOP flag of 
> poll()?

Yes, Me or someone from our team will do that.

-Eliezer
