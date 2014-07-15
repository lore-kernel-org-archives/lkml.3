Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaGOPzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:55:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56132 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaGOPzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:55:16 -0400
Message-ID: <53C54DDC.8060302@zytor.com>
Date: Tue, 15 Jul 2014 08:50:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86_64,xen,espfix: Initialize espfix on secondary CPUs
References: <195642a5e9fd4515ad8ca4cd8bcffd4900df5790.1405437568.git.luto@amacapital.net> <20140715153801.GX3403@laptop.dumpdata.com>
In-Reply-To: <20140715153801.GX3403@laptop.dumpdata.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 08:38 AM, Konrad Rzeszutek Wilk wrote:
> 
> I think just disallowing would be preferrable.
> 

So I have yet to hear anyone talk about what the Xen PV IRET does for
16-bit stack segments.  Can we get the answer for that, please?

	-hpa


