Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaBLNnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:43:37 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:41493 "EHLO
	smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaBLNnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:43:35 -0500
X-IronPort-AV: E=Sophos;i="4.95,832,1384300800"; 
   d="scan'208";a="78967151"
Message-ID: <52FB7A7B.2060102@amazon.de>
Date: Wed, 12 Feb 2014 14:43:23 +0100
From: "Egger, Christoph" <chegger@amazon.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthew Rushton <mrushton7@yahoo.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>
CC: "msw@amazon.com" <msw@amazon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "aliguori@amazon.com" <aliguori@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH v2 4/4] xen-blkif: drop struct blkif_request_segment_aligned
References: <1391744311.40091.YahooMailNeo@web122606.mail.ne1.yahoo.com>
In-Reply-To: <1391744311.40091.YahooMailNeo@web122606.mail.ne1.yahoo.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.02.14 04:38, Matthew Rushton wrote:
>> This was wrongly introduced in commit 402b27f9, the only difference
>> between blkif_request_segment_aligned and blkif_request_segment is
>> that the former has a named padding, while both share the same
>> memory layout.
>>
>> Also correct a few minor glitches in the description, including for it
>> to no longer assume PAGE_SIZE == 4096.
> 
> Tested-by: Matt Rushton <mrushton@amazon.com>
> 
> *Corrected subject line from last email and resent. I tested the set and
> everything looks solid. I also reviewed patch 2 and 3.
> 

Tested-by: Christoph Egger <chegger@amazon.de>
Reviewed-by: Christoph Egger <chegger@amazon.de>

Christoph

