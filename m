Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaIEQz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:55:26 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46717 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaIEQzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:55:24 -0400
Date: Fri, 5 Sep 2014 17:55:20 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, peppe.cavallaro@st.com
Subject: Re: [PATCH v6 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140905165520.GA25253@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1409931392-22340-1-git-send-email-peter.griffin@linaro.org>
 <1409931392-22340-2-git-send-email-peter.griffin@linaro.org>
 <20140905154700.GE24449@saruman.home>
 <20140905155321.GF24449@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905155321.GF24449@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Fri, 05 Sep 2014, Felipe Balbi wrote:
> > > +
> > > +	device_for_each_child(&pdev->dev, NULL, st_dwc3_remove_child);
> > 
> > same as before, of_platform_depopulate(). I can fix this one myself this
> > time.

Oh sorry, not sure what happened there, thanks for fixing it up:-)
> 
> it's in my testign/next branch, please make sure it looks alright.

Just checked and it looks good.

regards,

Peter.



