Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaBLNnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:43:32 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:41493 "EHLO
	smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaBLNna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:43:30 -0500
X-IronPort-AV: E=Sophos;i="4.95,832,1384300800"; 
   d="scan'208";a="78967094"
Message-ID: <52FB7A60.4000907@amazon.de>
Date: Wed, 12 Feb 2014 14:42:56 +0100
From: "Egger, Christoph" <chegger@amazon.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthew Rushton <mrushton7@yahoo.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>
CC: "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mrushton@amazon.com" <mrushton@amazon.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "msw@amazon.com" <msw@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "aliguori@amazon.com" <aliguori@amazon.com>
Subject: Re: [Xen-devel] [PATCH v2 3/4] xen-blkback: fix shutdown race
References: <1391743434.10989.YahooMailNeo@web122602.mail.ne1.yahoo.com>
In-Reply-To: <1391743434.10989.YahooMailNeo@web122602.mail.ne1.yahoo.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.02.14 04:23, Matthew Rushton wrote:
> On 04/02/14 10:26, Roger Pau Monne wrote:
>> Introduce a new variable to keep track of the number of in-flight
>> requests. We need to make sure that when xen_blkif_put is called the
>> request has already been freed and we can safely free xen_blkif, which
>> was not the case before.
> 
> Tested-by: Matt Rushton <mrushton@amazon.com>
> Reviewed-by: Matt Rushton <mrushton@amazon.com>

Tested-by: Christoph Egger <chegger@amazon.de>
Reviewed-by: Christoph Egger <chegger@amazon.de>

Christoph

