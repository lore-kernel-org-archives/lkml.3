Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaABMwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:52:50 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:45003 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaABMwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:52:49 -0500
X-IronPort-AV: E=Sophos;i="4.95,590,1384300800"; 
   d="scan'208";a="87020409"
Message-ID: <52C5611D.3020600@citrix.com>
Date: Thu, 2 Jan 2014 12:52:45 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <boris.ostrovsky@oracle.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow xenfb initialization for hvm guests
References: <alpine.DEB.2.02.1312171738550.8667@kaball.uk.xensource.com> <20131231145001.GA3349@phenom.dumpdata.com>
In-Reply-To: <20131231145001.GA3349@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/12/13 14:50, Konrad Rzeszutek Wilk wrote:
> On Tue, Dec 17, 2013 at 05:53:13PM +0000, Stefano Stabellini wrote:
>> There is no reasons why an HVM guest shouldn't be allowed to use xenfb.
>> As a matter of fact ARM guests, HVM from Linux POV, can use xenfb.
>> Given that no Xen toolstacks configure a xenfb backend for x86 HVM
>> guests, they are not affected.
> 
> Could you reference the upstream git commit that enables this.
> 
> And also CC the maintainers of drivers/video/*
> 
> And lastly lets CC also David and Boris on it.
> 
>>
>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: David Vrabel <david.vrabel@citrix.com>

David
