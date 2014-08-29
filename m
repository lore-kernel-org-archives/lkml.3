Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaH2TST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:18:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45949 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaH2TSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:18:17 -0400
Date: Fri, 29 Aug 2014 12:18:04 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2] ASoC: fsl-sai: using 'lsb-first' property instead of
 'big-endian-data'.
Message-ID: <20140829191803.GA7756@Asurada>
References: <20140829110601.GB21473@leverpostej>
 <20140829115943.GV29327@sirena.org.uk>
 <20140829164010.GA5520@Asurada>
 <20140829172601.GC18555@leverpostej>
 <20140829174019.GA5536@Asurada>
 <20140829191141.GA29327@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829191141.GA29327@sirena.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 08:11:41PM +0100, Mark Brown wrote:
> On Fri, Aug 29, 2014 at 10:40:20AM -0700, Nicolin Chen wrote:
> 
> > Agreed, it's better to be described in the commit comments as well.
> 
> > And regarding the compatibility with the old DT, I personally prefer
> > it to be added in the change for safety but if this case is allowable
> > which I'm not so sure about it, I'm fairly okay with the rename.
> 
> If you're happy I can easily add a note, but keeping the old property

That will be helpful, thank you :)

> would remove all doubt :)  I'll wait for either an ack or a respin.

Yea, I'm fine with it. Acked.

Thanks
Nicolin
