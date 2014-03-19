Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbaCSWOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:14:12 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:38572 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbaCSWOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:14:10 -0400
Date: Wed, 19 Mar 2014 16:14:04 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2a RESEND 2/2] of_mdio: Allow the DT to specify the phy
 ID and avoid autoprobing
Message-ID: <20140319221404.GA1154@obsidianresearch.com>
References: <1394658311-17769-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1394658311-17769-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <CAL_Jsq+qdbiwXErkZv1zZ9rphYY9NP6zHmmjw313tMvGeSTODg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+qdbiwXErkZv1zZ9rphYY9NP6zHmmjw313tMvGeSTODg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 04:35:54PM -0500, Rob Herring wrote:

> > Florian, do you know what path to mainline a this patch should take?
> 
> Via David's net tree.

Thanks

> > +       cp = of_get_property(device, "compatible", &cplen);
> > +       if (cp == NULL)
> > +               return -EINVAL;
> > +       while (cplen > 0) {
> 
> This can all be:
> 
>   of_property_for_each_string(device, "compatible", prop, cp)

Done

On Thu, Mar 13, 2014 at 01:46:18AM +0300, Sergei Shtylyov wrote:
>    The preferred multi-line comment style is:
> 
> /*
>  * bla
>  * bla
>  */
> 

Sergei, the entire file use the 'net' multi-line commenting style, and
I have maintined that consistency with the new code.

v3 on its way.

Regards,
Jason
