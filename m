Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3DZTYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:24:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62970 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3DZTYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:24:48 -0400
Message-ID: <517AD46A.2020402@gmail.com>
Date: Fri, 26 Apr 2013 21:24:26 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Marek Belisko <marek.belisko@gmail.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        alsa-devel@alsa-project.org,
        Michal Bachraty <michal.bachraty@streamunlimited.com>,
        linux-doc@vger.kernel.org, tiwai@suse.de,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, Marek Belisko <marek.belisko@streamunlimited.com>,
        perex@perex.cz
Subject: Re: [PATCH v2 2/3] ASoC: spdif_transmitter: Add DT support.
References: <1366895594-19596-1-git-send-email-marek.belisko@streamunlimited.com> <1366895594-19596-3-git-send-email-marek.belisko@streamunlimited.com>
In-Reply-To: <1366895594-19596-3-git-send-email-marek.belisko@streamunlimited.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 03:13 PM, Marek Belisko wrote:
> Add devicetree support for this dummy audio soc driver.
>
> Signed-off-by: Michal Bachraty<michal.bachraty@streamunlimited.com>
> Signed-off-by: Marek Belisko<marek.belisko@streamunlimited.com>
> ---
>   .../bindings/sound/spdif-transmitter.txt           |   10 ++++++++++
>   sound/soc/codecs/spdif_transmitter.c               |   10 ++++++++++
>   2 files changed, 20 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/sound/spdif-transmitter.txt
>
> diff --git a/Documentation/devicetree/bindings/sound/spdif-transmitter.txt b/Documentation/devicetree/bindings/sound/spdif-transmitter.txt
> new file mode 100644
> index 0000000..55a8584
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/sound/spdif-transmitter.txt
> @@ -0,0 +1,10 @@
> +Device-Tree bindings for dummy spdif transmitter
> +
> +Required properties:
> +	- compatible: should be "linux,spdif-dit".

Marek,

I remember Daniel commenting on the name already, but
what about "spdif-transmitter" and "spdif-receiver" respectively?
That is very generic and should allow to remove "linux," prefix.
And there is a lot of drivers using more informative compatible
strings compared to the driver name.

Sebastian
