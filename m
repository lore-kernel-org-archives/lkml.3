Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaG1Nrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:47:48 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21083 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaG1Nrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:47:47 -0400
X-IronPort-AV: E=Sophos;i="5.01,749,1400025600"; 
   d="scan'208";a="156901395"
Message-ID: <53D6547F.8010300@citrix.com>
Date: Mon, 28 Jul 2014 14:47:43 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <stefano.stabellini@eu.citrix.com>, <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Andrew Jones <drjones@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 4/4] xen/pvhvm: Make MSI IRQs work after kexec
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>	<1405431640-649-5-git-send-email-vkuznets@redhat.com>	<20140715152105.GP3403@laptop.dumpdata.com>	<87fvi1u16k.fsf@vitty.brq.redhat.com>	<20140716134050.GH19585@laptop.dumpdata.com> <87egxljk48.fsf@vitty.brq.redhat.com>
In-Reply-To: <87egxljk48.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/14 18:20, Vitaly Kuznetsov wrote:
> 
> Thanks, that really works! I tested both kexec -e / kdump cases. I'm
> wondering if we although need my commit to workaround non-fixed qemus?

I don't think so.

David
