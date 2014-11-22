Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaKVPYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 10:24:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:10547 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaKVPYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 10:24:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,437,1413270000"; 
   d="scan'208";a="612359179"
From: "Jones, Peter A" <peter.a.jones@intel.com>
To: Joe Perches <joe@perches.com>,
        "hpdd-discuss-owner@lists.01.org" <hpdd-discuss-owner@ml01.01.org>
CC: "Drokin, Oleg" <oleg.drokin@intel.com>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Is the list moderated or not?
Thread-Topic: Is the list moderated or not?
Thread-Index: AQHQBRx8c3BK8p9hKEuHy5fYCk7Im5xsxqWA
Date: Sat, 22 Nov 2014 15:24:14 +0000
Message-ID: <D095EA47.77977%peter.a.jones@intel.com>
References: <mailman.31138.1416527032.9748.hpdd-discuss@lists.01.org>
 <1416527288.6651.27.camel@perches.com>
In-Reply-To: <1416527288.6651.27.camel@perches.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.131.6]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E67238858A345A4EBA48546FA2B3B7BB@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Joe. This list has traditionally always been moderated but I guess
something was changed at some point (probably when we joined Intel). I
have adjusted the list to be moderated and it behaved as expected in my
tests. Thanks for drawing our attention to this!

On 11/20/14, 3:48 PM, "Joe Perches" <joe@perches.com> wrote:

>On Thu, 2014-11-20 at 15:43 -0800, hpdd-discuss-owner@lists.01.org
>wrote:
>> You must be a subscriber to post to this list. Please make sure you
>> are sending from a subscribed email address.
>
>The linux-kernel MAINTAINERS file has this as a moderated list.
>If it's not moderated, this entry should be changed to subscriber-only.
>
>STAGING - LUSTRE PARALLEL FILESYSTEM
>M:	Oleg Drokin <oleg.drokin@intel.com>
>M:	Andreas Dilger <andreas.dilger@intel.com>
>L:	HPDD-discuss@lists.01.org (moderated for non-subscribers)
>W:	http://lustre.opensfs.org/
>S:	Maintained
>F:	drivers/staging/lustre
>
>If it's really subscriber only, please change the L: line to:
>
>L:	HPDD-discuss@lists.01.org (subscribers-only)
>
>

