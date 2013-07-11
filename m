Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab3GKNfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:35:48 -0400
Received: from smtp.citrix.com ([66.165.176.89]:43226 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894Ab3GKNfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:35:45 -0400
X-IronPort-AV: E=Sophos;i="4.87,1043,1363132800"; 
   d="scan'208";a="36379083"
Message-ID: <51DEB4AF.5070307@citrix.com>
Date: Thu, 11 Jul 2013 14:35:43 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 0/4] xen-block: prevent blkfront for	hoarding
 grants
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/13 14:03, Roger Pau Monne wrote:
> This series also includes a bug fix for the grant table free callback 
> implementation.

I think this should have been split out from this series.

> According to my tests, this series don't introduce any performance 
> regressions, results can be seen at:
> 
> http://xenbits.xen.org/people/royger/persistent_unmap/

The graphs do show performance differences (although they don't look
significant).  They are also lacking any error bars or any explanation
of what the tests were and what the test system was.

David
