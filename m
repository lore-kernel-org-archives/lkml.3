Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3FFUS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:18:27 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36426 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab3FFUS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:18:26 -0400
Message-ID: <51B0EE85.1000905@linux.vnet.ibm.com>
Date: Thu, 06 Jun 2013 15:18:13 -0500
From: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, Cong Wang <amwang@redhat.com>,
        Amos Kong <akong@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH] virtio-net: put virtio net header inline
 with data
References: <20130606095456.GA7865@redhat.com> <51B0EA30.3020804@linux.vnet.ibm.com> <20130606200932.GB3837@redhat.com>
In-Reply-To: <20130606200932.GB3837@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060620-5806-0000-0000-00002192DFDD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 03:09 PM, Dave Jones wrote:
> On Thu, Jun 06, 2013 at 02:59:44PM -0500, Jesse Larrew wrote:
> 
>  > >  	pr_debug("%s: xmit %p %pM\n", vi->dev->name, skb, dest);
>  > > +	if (vi->mergeable_rx_bufs)
>  > > +		hdr_len = sizeof hdr->mhdr;
>  > > +	else
>  > > +		hdr_len = sizeof hdr->hdr;
>  > 
>  > All conditionals need braces.
> 
> Documentation/CodingStyle disagrees:
> 
>  "Do not unnecessarily use braces where a single statement will do."
> 
> 	Dave 
> 

Ah, yes. This is kernel code. My mistake. :)

Jesse Larrew
Software Engineer, KVM Team
IBM Linux Technology Center
Phone: (512) 973-2052 (T/L: 363-2052)
jlarrew@linux.vnet.ibm.com

