Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbaALXUD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 18:20:03 -0500
Received: from smtp.citrix.com ([66.165.176.89]:47024 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaALXUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 18:20:01 -0500
X-IronPort-AV: E=Sophos;i="4.95,649,1384300800"; 
   d="scan'208";a="92160028"
Message-ID: <52D3230A.3020203@citrix.com>
Date: Sun, 12 Jan 2014 23:19:38 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <jonathan.davies@citrix.com>, <ian.campbell@citrix.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH net-next v3 2/9] xen-netback: Change TX path
 from grant copy to mapping
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com>	<1389139818-24458-3-git-send-email-zoltan.kiss@citrix.com>	<20140109153015.GF12164@zion.uk.xensource.com>	<52CFDAEC.5080708@citrix.com>	<20140110114534.GE29180@zion.uk.xensource.com> <52D01094.5060102@citrix.com> <52D0198C.6000600@citrix.com>
In-Reply-To: <52D0198C.6000600@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.14.27]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/14 16:02, David Vrabel wrote:
> On 10/01/14 15:24, Zoltan Kiss wrote:
> If the grant table code doesn't provide the API calls you need you can
> either:
>
> a) add the new API as a prerequisite patch.
> b) use the existing API calls and live with the performance problem,
> until you can refactor the API later on.
>
> Adding a netback-specific hack isn't a valid option.
>
> David

Ok, I've sent in the patch which does a)

Zoli
