Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaH2Qk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:40:27 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56773 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaH2QkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:40:25 -0400
Date: Fri, 29 Aug 2014 09:40:11 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2] ASoC: fsl-sai: using 'lsb-first' property instead of
 'big-endian-data'.
Message-ID: <20140829164010.GA5520@Asurada>
References: <20140829110601.GB21473@leverpostej>
 <20140829115943.GV29327@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829115943.GV29327@sirena.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 12:59:43PM +0100, Mark Brown wrote:
> On Fri, Aug 29, 2014 at 12:06:01PM +0100, Mark Rutland wrote:
> > On Fri, Aug 29, 2014 at 08:12:12AM +0100, Xiubo Li wrote:
> 
> > > The 'big-endian-data' property is originally used to indicate whether the
> > > LSB firstly or MSB firstly will be transmitted to the CODEC or received
> > > from the CODEC, and there has nothing relation to the memory data.
> 
> > Both Nicolin [1] and Mark [2] asked for the old property to be kept
> > around for compatibility reasons. Those requests seem to have been
> > ignored entirely; the commit message doesn't even describe why you
> > believe removing support for the old property is safe.
> 
> The response was that the relevant chips aren't out in the wild so it's
> vanishingly unlikely that anyone would have a real DT with this option
> enabled.  I'll defer to Nicolin on if that's the case or not.

Yea, it sounds like so. I thought Vf610 also used this property. But if
only LS1 using it, I think we may consent this rename right?

Nicolin
