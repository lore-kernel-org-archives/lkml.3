Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3BVJVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:21:19 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:17028
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755210Ab3BVJVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:21:16 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275dhz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
Date: Fri, 22 Feb 2013 17:20:56 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Alexander Shiyan <shc_work@mail.ru>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4] mfd: syscon: Add non-DT support
Message-ID: <20130222092055.GF3252@b29396-Latitude-E6410>
References: <1361460542-2872-1-git-send-email-shc_work@mail.ru>
 <20130222065548.GA3252@b29396-Latitude-E6410>
 <1361516478.223331042@f282.mail.ru>
 <20130222071311.GB3252@b29396-Latitude-E6410>
 <20130222072718.GA24114@avionic-0098.mockup.avionic-design.de>
 <20130222082954.GD3252@b29396-Latitude-E6410>
 <20130222085212.GA27653@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130222085212.GA27653@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 09:52:12AM +0100, Thierry Reding wrote:
> On Fri, Feb 22, 2013 at 04:29:55PM +0800, Dong Aisheng wrote:
> > On Fri, Feb 22, 2013 at 08:27:19AM +0100, Thierry Reding wrote:
> > ...
> > > > > > Otherwise, i'm also ok with this patch.
> > > > > > Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> > > > > > 
> > > > > > BTW, i did not see Samuel's tree having this new API.
> > > > > > So, who will pick this patch?
> > > > > 
> > > > > I have same question.
> > > > 
> > > > I CCed Thierry and Greg who may know it.
> > > 
> > > Yes, devm_ioremap_resource() never returns NULL. You always need to
> > > check the returned pointer with IS_ERR(). The value that you return
> > > should be extracted from the pointer with PTR_ERR().
> > 
> > Thanks Thierry.
> > Since Samuel's mdf tree does not have your patch introducing
> > the new API of devm_ioremap_resource,
> > do you know which tree this patch can go through, Greg's driver core tree?
> 
> I don't think it matters much at this point because Linus merged the
> driver core tree yesterday, so anything that gets applied now should
> automatically have the new API available.
> 
I just tried update to latest linus tree, still did not find this API defined
in include/linux/io.h.
Would you mind point it out for me?

Regards
Dong Aisheng

