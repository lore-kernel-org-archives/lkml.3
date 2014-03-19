Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbaCSWgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:36:40 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:36999 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549AbaCSWgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:36:39 -0400
Date: Wed, 19 Mar 2014 16:36:33 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2a RESEND 2/2] of_mdio: Allow the DT to specify the phy
 ID and avoid autoprobing
Message-ID: <20140319223633.GC1154@obsidianresearch.com>
References: <1394658311-17769-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1394658311-17769-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <CAL_Jsq+qdbiwXErkZv1zZ9rphYY9NP6zHmmjw313tMvGeSTODg@mail.gmail.com>
 <20140319221404.GA1154@obsidianresearch.com>
 <532A262B.803@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532A262B.803@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 02:20:11AM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 03/20/2014 01:14 AM, Jason Gunthorpe wrote:
> 
> >>    The preferred multi-line comment style is:
> 
> >>/*
> >>  * bla
> >>  * bla
> >>  */
> 
> >Sergei, the entire file use the 'net' multi-line commenting style, and
> >I have maintined that consistency with the new code.
> 
>    No, you haven't followed the networking style. It is:
> 
> /* bla
>  * bla
>  */
> 
> while your comment used:
> 
> /* bla
>  * bla */

Oh Ok - but the latter is the used by the majority of pre-existing
comments..

I thought the convention on stuff like this was to stick with the
existing style?

Do you think it is worth a v4? If so, which style is appropriate?
There is one other pre-existing comment that uses net.

Regards,
Jason
