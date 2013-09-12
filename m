Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3ILPAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:00:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47773 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3ILPA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:00:28 -0400
Message-ID: <5231D709.5080308@wwwdotorg.org>
Date: Thu, 12 Sep 2013 09:00:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: khali@linux-fr.org, linux@roeck-us.net, broonie@kernel.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] Documentation: dt: hwmon: add OF document for
 LM90
References: <1378985061-28547-1-git-send-email-wni@nvidia.com> <1378985061-28547-4-git-send-email-wni@nvidia.com>
In-Reply-To: <1378985061-28547-4-git-send-email-wni@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 05:24 AM, Wei Ni wrote:
> Add OF document for LM90 in Documentation/devicetree/.

> diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt b/Documentation/devicetree/bindings/hwmon/lm90.txt

> +Optional properties:
> +- vcc-supply: vcc regulator for the supply voltage.
> +              If this is not set, assuming vcc is always powered.

I thought that was going to be a "Required Property".
