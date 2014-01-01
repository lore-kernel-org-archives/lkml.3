Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaAAULI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 15:11:08 -0500
Received: from smtp-out-181.synserver.de ([212.40.185.181]:1034 "EHLO
	smtp-out-079.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754132AbaAAULG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 15:11:06 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 26234
Message-ID: <52C4766B.8080000@metafoo.de>
Date: Wed, 01 Jan 2014 21:11:23 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: generic: add generic compound card
 with DT support
References: <20131231113138.102044cf@armhf> <52C466E1.3030302@metafoo.de> <20140101210814.31e3f3a9@armhf>
In-Reply-To: <20140101210814.31e3f3a9@armhf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2014 09:08 PM, Jean-Francois Moine wrote:
> On Wed, 01 Jan 2014 20:05:05 +0100
> Lars-Peter Clausen <lars@metafoo.de> wrote:
> 
>> As Mark also said, this binding definitely leaks way too much internals of
>> the current ASoC implementation. In my opinion the way forward for ASoC is
>> to stop to distinguish between different types of components. This is on one
>> hand CODECS and CPU-DAIs and on the other hand also front-end and beck-end
>> DAIs. The first steps in this direction have already been take by the start
>> of the component-fication, but its still a long way to go. Exposing those
>> concepts via the devicetree will only make it harder to get rid of them
>> later. The bindings for a compound card should essentially describe which
>> components are involved and how the fabric between and around them looks
>> like. If the type of the component is needed in the ASoC implementation it
>> should be possible to auto-discover it. Also I think we want to align the
>> devicetree bindings with what the media people have been doing[1].
> 
> (you forgot the [1] reference)

http://lxr.free-electrons.com/source/Documentation/devicetree/bindings/media/video-interfaces.txt
