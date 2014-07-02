Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaGBKTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:19:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45870 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaGBKTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:19:36 -0400
Date: Wed, 2 Jul 2014 11:19:27 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, srinivas.kandagatla@gmail.com,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: STi: STiH407: Add reset controller support.
Message-ID: <20140702101927.GC8809@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1404225047-9495-1-git-send-email-peter.griffin@linaro.org>
 <1404225047-9495-4-git-send-email-peter.griffin@linaro.org>
 <20140702085102.GF10311@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702085102.GF10311@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

> > +		picophyreset: picophyreset-controller {
> > +			#reset-cells = <1>;
> > +			compatible = "st,stih407-picophyreset";
> > +		};
> > +
> 
> I'd always put the compatible string at the very top of the node.

Thanks for reviewing, have changed in v2.

regards,

Peter.
