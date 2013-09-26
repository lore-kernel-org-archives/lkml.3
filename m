Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939Ab3IZNwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:52:41 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:43981 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750Ab3IZNwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:52:36 -0400
Message-ID: <52443B71.7060402@st.com>
Date: Thu, 26 Sep 2013 14:49:37 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-media@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: st-rc: Add ST remote control driver
References: <1379581176-25078-1-git-send-email-srinivas.kandagatla@st.com> <5240A740.7000407@wwwdotorg.org> <5241488F.5010000@st.com> <5241ECCC.3020808@wwwdotorg.org>
In-Reply-To: <5241ECCC.3020808@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 24/09/13 20:49, Stephen Warren wrote:
>>> >> Should those property names be prefixed with "st,"; I assume they're
>>> >> specific to this binding rather than something generic that applies to
>>> >> all IR controller bindings? If you expect them to be generic, it's fine.
>> > 
>> > Officially these bindings are not specified in ePAPR specs
> Well, there are plenty of properties we now consider generic that aren't
> in ePAPR...
> 
>> > but I see no reason for not having these properties as generic ones.
>> >
>> > Are you ok with that?
> I suppose that infrared-vs-uhf is a concept that's probably common
> enough across any similar HW device, so it may make sense for these
> properties to be generic. If we do intend them to be generic, I'd
> suggest they be defined in some generic binding document though; perhaps
> something like bindings/media/ir.txt or
> bindings/media/remote-control.txt? That way, a HW-specific binding isn't
> the only place where a supposedly generic property is defined.

For now I will send a v5 for this driver with these generic properties.

And, I will send an separate RFC for the generic binding document
(bindings/media/remote-control.txt) so that we can get more inputs from
others as well.

Thanks,
srini

> 
> 

