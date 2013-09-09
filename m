Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab3IIWQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 18:16:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50215 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab3IIWQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 18:16:00 -0400
Message-ID: <522E489D.6080903@wwwdotorg.org>
Date: Mon, 09 Sep 2013 16:15:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: khali@linux-fr.org, linux@roeck-us.net, broonie@kernel.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] Documentation: dt: hwmon: add OF document for
 LM90
References: <1378722552-10357-1-git-send-email-wni@nvidia.com> <1378722552-10357-3-git-send-email-wni@nvidia.com>
In-Reply-To: <1378722552-10357-3-git-send-email-wni@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 04:29 AM, Wei Ni wrote:
> Add OF document for LM90 in Documentation/devicetree/.

> diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt
> b/Documentation/devicetree/bindings/hwmon/lm90.txt

> +Optional properties:

> +- interrupts: Contains a single interrupt specifier which
> describes the +              LM90 pin6 output.

Does the pin also have a standard name you could include here, rather
than (or in addition to) just the pin number?
