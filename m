Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaCYXAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:00:00 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:65395 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbaCYW74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:59:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Gabriel Fernandez <gabriel.fernandez@st.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <53313E39.9080605@st.com>
Cc: "Lee Jones" <lee.jones@linaro.org>, "Pankaj Dev" <pankaj.dev@st.com>
References: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
 <1393514668-17440-2-git-send-email-gabriel.fernandez@st.com>
 <20140325052725.32624.39974@quantum> <53313E39.9080605@st.com>
Message-ID: <20140325225946.5762.56339@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v0 01/15] drivers: clk: st: Support for DIVMUX and PreDiv Clocks
Date: Tue, 25 Mar 2014 15:59:46 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gabriel Fernandez (2014-03-25 01:28:41)
> Hi Mike,
> 
> I want that you take theses patches directly.

Sure, I've taken patches #1-10 into clk-next.

Regards,
Mike

> 
> Many thanks
> 
> 
> Best regards
> 
> Gabriel.
> 
> 
> On 03/25/2014 06:27 AM, Mike Turquette wrote:
> > Quoting Gabriel FERNANDEZ (2014-02-27 07:24:14)
> >> +/**
> >> + * DOC: Clock mux with a programmable divider on each of its three inputs.
> >> + *      The mux has an input setting which effectively gates its output.
> >> + *
> >> + * Traits of this clock:
> >> + * prepare - clk_(un)prepare only ensures parent is (un)prepared
> > Minor nitpick but it doesn't look like .prepare or .unprepare are
> > supported below. It looks like this copy/paste comment applies to most
> > of the clk patches as well.
> >
> > It's a small problem and doesn't require a patch respin. But perhaps can
> > be cleaned up some day in the future.
> >
> > Do you want me to take these patches directly or are you just looking
> > for an Ack?
> >
> > Regards,
> > Mike
> 
