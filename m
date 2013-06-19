Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932Ab3FSWhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:37:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39953 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935295Ab3FSWhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:37:21 -0400
Message-ID: <51C2329D.9040408@wwwdotorg.org>
Date: Wed, 19 Jun 2013 16:37:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 3/4] GPIO: Add TB10x GPIO driver
References: <20130618092516.GC18663@ab42.lan> <1371547751-13873-3-git-send-email-christian.ruppert@abilis.com>
In-Reply-To: <1371547751-13873-3-git-send-email-christian.ruppert@abilis.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 03:29 AM, Christian Ruppert wrote:
> The GPIO driver for the Abilis Systems TB10x series of SOCs based on ARC700
> CPUs. It supports GPIO control and GPIO interrupt generation. This driver
> works in conjunction with the TB10x pinctrl driver.

Just one comment on the binding (I didn't read the code):

> diff --git a/Documentation/devicetree/bindings/gpio/abilis,tb10x-gpio.txt b/Documentation/devicetree/bindings/gpio/abilis,tb10x-gpio.txt

> +Required Properties:

> +- ngpio: the number of GPIO pins this driver controls.

That's a custom property, so should include a vendor prefix: abilis,ngpios.

