Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab3LKLsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:48:06 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:48972 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370Ab3LKLsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:48:02 -0500
Message-ID: <52A84F71.7080903@st.com>
Date: Wed, 11 Dec 2013 11:41:37 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
Cc: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/5] dt/bindings: Remove all references to device_type
 "ethernet-phy"
References: <1386760555-22732-1-git-send-email-grant.likely@linaro.org> <1386760555-22732-2-git-send-email-grant.likely@linaro.org>
In-Reply-To: <1386760555-22732-2-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 11:15, Grant Likely wrote:
> The device_type property is deprecated for the flattened device tree and
> the value "ethernet-phy" has never been defined as having a useful
> meaning. Neither the kernel nor u-boot depend on it. It should never
> have appeared in PHY bindings. This patch removes all references to
> "ethernet-phy" as a device_type value from the documentation and the
> .dts files.
Makes sense...

Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

> 
> This patch was generated mechanically with the following command and
> then verified by looking at the diff.
> 
> sed -i '/"ethernet-phy"/d' `git grep -l '"ethernet-phy"'`
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

