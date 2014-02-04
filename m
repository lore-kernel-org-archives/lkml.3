Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaBDPII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:08:08 -0500
Received: from smtp.citrix.com ([66.165.176.89]:62658 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaBDPIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:08:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,780,1384300800"; 
   d="scan'208";a="99675779"
Message-ID: <52F1024D.7070302@citrix.com>
Date: Tue, 4 Feb 2014 15:07:57 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matt Wilson <msw@linux.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        <stefano.stabellini@eu.citrix.com>,
        Anthony Liguori <aliguori@amazon.com>, Matt Wilson <msw@amazon.com>
Subject: Re: [PATCH v7] xen/grant-table: Avoid m2p_override during mapping
References: <1391433898-10533-1-git-send-email-zoltan.kiss@citrix.com> <20140204063648.GB19177@u109add4315675089e695.ant.amazon.com>
In-Reply-To: <20140204063648.GB19177@u109add4315675089e695.ant.amazon.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/14 06:36, Matt Wilson wrote:
> On Mon, Feb 03, 2014 at 01:24:58PM +0000, Zoltan Kiss wrote:
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> Suggested-by: David Vrabel <david.vrabel@citrix.com>
>
> You're still forgetting that this was originally proposed by Anthony
> Liguori <aliguori@amazon.com>.
>
> https://lkml.kernel.org/r/1384307336-5328-1-git-send-email-anthony@codemonkey.ws

Sure, sorry. I've talked with David, I will add Anthony as Original-by, 
instead of David's Suggested-by line.

Zoli
