Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbaCTN3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:29:49 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:52922 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610AbaCTN3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:29:48 -0400
Date: Thu, 20 Mar 2014 13:29:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        angus.clark@st.com
Subject: Re: [PATCH 1/5] mtd: st_spi_fsm: Remove useless consts from function
 arguments
Message-ID: <20140320132942.GA6816@lee--X1>
References: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
 <1395313907-25318-2-git-send-email-lee.jones@linaro.org>
 <1395314713.7776.17.camel@joe-AO722>
 <20140320114123.GE21349@lee--X1>
 <1395316090.7776.24.camel@joe-AO722>
 <20140320115412.GU31517@norris-Latitude-E6410>
 <20140320120307.GA9240@lee--X1>
 <1395317630.7776.29.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395317630.7776.29.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Good catch. That wasn't my intention.
> > > > Why?
> > An oversight.
> 
> That's still not an explanation.
> 
> Why, unless cast away by the code itself, is
> const removal a good thing?
> 
> It does serve as an indication to a reader what
> the code does with the argument.
> 
> About the only reason I can think of arguing in
> favor of removal is inconsistent application of
> const within the module.

Your qualm is not with me in this instance. I don't ever mind holding
my hands up to mistakes I make or standing up for decisions I believe
in, but in this case I'm merely satisfying the wishes of a maintainer
I'm submitting code to.

I am strongly un-opinionated about these particular changes.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
