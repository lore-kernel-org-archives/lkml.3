Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3BVHN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:13:27 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:47460
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753557Ab3BVHNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:13:25 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432I179dNzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275dh6d523h5e7bkz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
Date: Fri, 22 Feb 2013 15:13:12 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Alexander Shiyan <shc_work@mail.ru>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <thierry.reding@avionic-design.de>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4] mfd: syscon: Add non-DT support
Message-ID: <20130222071311.GB3252@b29396-Latitude-E6410>
References: <1361460542-2872-1-git-send-email-shc_work@mail.ru>
 <20130222065548.GA3252@b29396-Latitude-E6410>
 <1361516478.223331042@f282.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1361516478.223331042@f282.mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 11:01:18AM +0400, Alexander Shiyan wrote:
> > On Thu, Feb 21, 2013 at 07:29:02PM +0400, Alexander Shiyan wrote:
> > > This patch allow using syscon driver from the platform data, i.e.
> > > possibility using driver on systems without oftree support.
> > > For search syscon device from the client drivers,
> > > "syscon_regmap_lookup_by_pdevname" function was added.
> > > 
> > > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > 
> > [...]
> > 
> > > +	syscon->base = devm_ioremap_resource(dev, res);
> > > +	if (!syscon->base)
> > 
> > Is this correct?
> 
> Hmm, of course IS_ERR should be used here...
> v5?
> 

Yes.
>From here:
https://lkml.org/lkml/2013/1/21/140
It seems it is.

> > 
> > > +		return -EBUSY;

Both this line could also be changed.

> > >
> > 
> > Otherwise, i'm also ok with this patch.
> > Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > BTW, i did not see Samuel's tree having this new API.
> > So, who will pick this patch?
> 
> I have same question.

I CCed Thierry and Greg who may know it.

Regards
Dong Aisheng

