Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbaDGRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:16:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38298 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661AbaDGRQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:16:53 -0400
Message-ID: <5342DD7B.5070202@oracle.com>
Date: Mon, 07 Apr 2014 13:16:43 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: slub: gpf in deactivate_slab
References: <53208A87.2040907@oracle.com> <5331A6C3.2000303@oracle.com> <20140325165247.GA7519@dhcp22.suse.cz> <alpine.DEB.2.10.1403251205140.24534@nuc> <5331B9C8.7080106@oracle.com> <alpine.DEB.2.10.1403251308590.26471@nuc> <53321CB6.5050706@oracle.com> <alpine.DEB.2.10.1403261042360.2057@nuc> <53401F56.5090507@oracle.com> <alpine.DEB.2.10.1404071212200.9896@nuc>
In-Reply-To: <alpine.DEB.2.10.1404071212200.9896@nuc>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 01:13 PM, Christoph Lameter wrote:
> On Sat, 5 Apr 2014, Sasha Levin wrote:
> 
>> Unfortunately I've been unable to reproduce the issue to get more debug info
>> out of it. However, I've hit something that seems to be somewhat similar
>> to that:
> 
> Could you jsut run with "slub_debug" on the kernel command line to get us
> more diagnostics? Could be memory corruption.

I was running it with "slub_debug=FZPU" when I reported both errors,
there was no other information beyond the traces in the log.


Thanks,
Sasha
