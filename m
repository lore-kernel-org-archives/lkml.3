Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaDAGIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:08:45 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16525 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaDAGIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:08:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 31 Mar 2014 23:04:19 -0700
From: Arun Shamanna Lakshmi <aruns@nvidia.com>
To: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
CC: Songhee Baek <sbaek@nvidia.com>,
        "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "'swarren@wwwdotorg.org'" <swarren@wwwdotorg.org>,
        "'tiwai@suse.de'" <tiwai@suse.de>,
        "'lgirdwood@gmail.com'" <lgirdwood@gmail.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Mon, 31 Mar 2014 23:08:42 -0700
Subject: RE: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
Thread-Topic: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
Thread-Index: Ac9M2eSQS4irsZZ7TfW4X9xEk1m+pQAlsgPQ
Message-ID: <781A12BB53C15A4BB37291FDE08C03F3A05CDCD520@HQMAIL02.nvidia.com>
References: <1395792156-4178-1-git-send-email-aruns@nvidia.com>
 <53332CC7.6060800@metafoo.de>
 <D6C615D3E4730340AE82D5BD856631C0A26CB319B2@HQMAIL02.nvidia.com>
 <5333ED3A.7040908@metafoo.de>
 <5571431004A69147BCABABE4E097D66BA3EFF70CFC@HQMAIL02.nvidia.com>
 <D6C615D3E4730340AE82D5BD856631C0A26CB31F48@HQMAIL02.nvidia.com>
 <5336A619.5030007@metafoo.de>
 <781A12BB53C15A4BB37291FDE08C03F3A05CC6A11A@HQMAIL02.nvidia.com>
 <20140331112140.GO2269@sirena.org.uk> <533957C8.2030105@metafoo.de>
 <20140331120748.GS2269@sirena.org.uk>
In-Reply-To: <20140331120748.GS2269@sirena.org.uk>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Monday, March 31, 2014 5:08 AM
> To: Lars-Peter Clausen
> Cc: Arun Shamanna Lakshmi; Songhee Baek; 'alsa-devel@alsa-project.org';
> 'swarren@wwwdotorg.org'; 'tiwai@suse.de'; 'lgirdwood@gmail.com'; 'linux-
> kernel@vger.kernel.org'
> Subject: Re: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
> 
> * PGP Signed by an unknown key
> 
> On Mon, Mar 31, 2014 at 01:55:52PM +0200, Lars-Peter Clausen wrote:
> > On 03/31/2014 01:21 PM, Mark Brown wrote:
> 
> > >The above is a bit confusing...  partly this is because of a lack of
> > >context (what is MULTI_MUX_INPUT_OFFSET?) and partly because it isn't
> > >entirely obvious that stopping as soon as we see any value set is the
> > >right choice, especially given the addition to rather than setting of
> > >val.
> 
> > I think the idea is that since we know that for one-hot encodings only
> > powers of two are valid values the other bits are used to encode the
> > register number. E.g 0x4 means bit 3 in register 0, 0x5 means bit 3 in
> > register 1, 0x6 means bit 3 in register 2 and so on. I guess it is
> > possible to make it work. But this seems to be quite hack-ish to me.
> > You'd have to be careful that MULTI_MUX_INPUT_OFFSET(reg_idx) never
> > evaluates to a power of two and there are probably some more pitfalls.
> 
> Ugh, right.  The fact that I couldn't tell that this was what the code was trying to
> do from looking at it is not a good sign here.

I will work on this and submit another patch. Thanks for all your feedback.

> 
> * Unknown Key
> * 0x7EA229BD
