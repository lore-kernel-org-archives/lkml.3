Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaDON3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:29:20 -0400
Received: from smtp.citrix.com ([66.165.176.89]:55879 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaDON3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:29:19 -0400
X-IronPort-AV: E=Sophos;i="4.97,864,1389744000"; 
   d="scan'208";a="121232827"
Message-ID: <534D342C.2040805@citrix.com>
Date: Tue, 15 Apr 2014 14:29:16 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/pci: Remove unused dev_err() string
References: <20140414222523.15032.99127.stgit@bhelgaas-glaptop.roam.corp.google.com> <20140415130319.GC29540@phenom.dumpdata.com>
In-Reply-To: <20140415130319.GC29540@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/14 14:03, Konrad Rzeszutek Wilk wrote:
> On Mon, Apr 14, 2014 at 04:25:23PM -0600, Bjorn Helgaas wrote:
>> We previously verified that "action" is either BUS_NOTIFY_ADD_DEVICE or
>> BUS_NOTIFY_DEL_DEVICE, so there's no need for the default "?" case.
>>
>> Found by Coverity (CID 146520).
> 
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> David, are you OK pushing this in 'devel/for-linus-3.14'?

If you mean devel/for-linus-3.16, then yes.

David
