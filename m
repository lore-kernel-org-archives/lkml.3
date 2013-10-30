Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3J3VOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:14:36 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4859 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab3J3VOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:14:35 -0400
X-IronPort-AV: E=Sophos;i="4.93,604,1378857600"; 
   d="scan'208";a="66473320"
Message-ID: <527176B8.3060703@citrix.com>
Date: Wed, 30 Oct 2013 21:14:32 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [Xen-devel] [PATCH net-next RFC 0/5] xen-netback: TX grant mapping
 instead of copy
References: <1383094220-14775-1-git-send-email-zoltan.kiss@citrix.com> <20131030191617.GB14149@phenom.dumpdata.com> <20131030191721.GA14261@phenom.dumpdata.com>
In-Reply-To: <20131030191721.GA14261@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/13 19:17, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 30, 2013 at 03:16:17PM -0400, Konrad Rzeszutek Wilk wrote:
>> Odd. I don't see #5 patch patch?
>
> Ah, you have two #4 patches:
>
> [PATCH net-next RFC 4/5] xen-netback: Change RX path for mapped SKB fragments
> [PATCH net-next RFC 4/5] xen-netback: Fix indentations

Yep, sorry, I will fix it up in the next version!

Zoli

