Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaG2Fb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 01:31:57 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53955 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaG2Fby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 01:31:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1405437631-23623-7-git-send-email-gabriel.fernandez@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, "Lee Jones" <lee.jones@linaro.org>,
        "Gabriel Fernandez" <gabriel.fernandez@linaro.org>,
        "Maxime Coquelin" <maxime.coquelin@st.com>,
        "Olivier Bideau" <olivier.bideau@st.com>
References: <1405437631-23623-1-git-send-email-gabriel.fernandez@linaro.org>
 <1405437631-23623-7-git-send-email-gabriel.fernandez@linaro.org>
Message-ID: <20140729053149.4906.84119@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v3 06/15] drivers: clk: st: STiH407: Support for Flexgen Clocks
Date: Mon, 28 Jul 2014 22:31:49 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gabriel FERNANDEZ (2014-07-15 08:20:22)
> +static const char ** __init flexgen_get_parents(struct device_node *np,
> +                                                      int *num_parents)
> +{
> +       const char **parents;
> +       int nparents, i;
> +
> +       nparents = of_count_phandle_with_args(np, "clocks", "#clock-cells");

FYI, of_clk_get_parent_count provides a nice wrapper around this. Maybe
you can update it some day? Not a blocking issue for this series.

Regards,
Mike
