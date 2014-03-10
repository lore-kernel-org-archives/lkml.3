Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaCJP6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:58:36 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:56978 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbaCJP6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:58:32 -0400
Date: Mon, 10 Mar 2014 08:58:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        kernel@stlinux.com, Giuseppe Condorelli <giuseppe.condorelli@st.com>
Subject: Re: [PATCH 1/5] drivers: input: keyboard: st-keyscan: add keyscan
 driver
Message-ID: <20140310155824.GB29054@core.coreip.homeip.net>
References: <1393990772-9567-1-git-send-email-gabriel.fernandez@st.com>
 <1393990772-9567-2-git-send-email-gabriel.fernandez@st.com>
 <20140310114819.GO14976@lee--X1>
 <20140310152859.GA29054@core.coreip.homeip.net>
 <20140310153815.GE13661@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310153815.GE13661@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 03:38:15PM +0000, Lee Jones wrote:
> > > > This patch adds ST Keyscan driver to use the keypad hw a subset
> > > > of ST boards provide. Specific board setup will be put in the
> > > > given dt.
> > > > 
> > > > Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
> > > > Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
> > > 
> > > Are you sure these are in the correct order?
> > > 
> > > What is the history of this commit?
> > > 
> > > > ---
> > > >  .../devicetree/bindings/input/st-keypad.txt        |  50 ++++
> > > 
> > > This should be submitted as a seperate patch.
> > 
> > Why do we have such requirement? To me it would make more sense to add
> > binding documentation in the same commit as the code that uses these
> > bindings.
> 
> I'm inclined to agree with you and that's actually how we used to do
> it, but a decision was made by the DT guys at one of the Kernel
> Summits to submit Documentation as a separate patch.

Do you have background for this decision? To me it is akin splitting
header file into a separate patch.

-- 
Dmitry
