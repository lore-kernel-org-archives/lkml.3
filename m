Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3LCJBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:01:08 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38647 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3LCJBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:01:04 -0500
MIME-Version: 1.0
In-Reply-To: <CEB92A62.3A401%bjorn.andersson@sonymobile.com>
References: <5293E7FB.6040300@wwwdotorg.org>
	<CEB92A62.3A401%bjorn.andersson@sonymobile.com>
Date: Tue, 3 Dec 2013 10:01:03 +0100
Message-ID: <CACRpkda515hO6daP_4FZEXiGJTPHUaT1-ZLUW7sjVtR7-XjuZQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: Add documentation for pinctrl-msm8x74
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Andersson=2C_Bj=F6rn?= 
	<Bjorn.Andersson@sonymobile.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 1:52 AM, "Andersson, Björn"
<Bjorn.Andersson@sonymobile.com> wrote:
> On 11/25/13 4:14 PM, "Stephen Warren" <swarren@wwwdotorg.org> wrote:

>>> +Optional subnode-properties:
>>> +- qcom,function: A name of the function to be muxed to the specified
>>> +                 pins. Possible values are listed below.
>>
>>Are "pins" and "functions" generic enough now that they don't need a
>>vendor prefix? Both those property names are certainly mentioned in
>>pinctrl-bindings.txt.
>
> I've missed that these where in pinconf-generic. I based
> msm_dt_subnode_to_map
> on the tegra implementation and made changes to support pinconf-generic,
> which
> now seems identical with pinconf_generic_dt_subnode_to_map.
> I'll use that directly instead.

OK that's essentially one of my comments on patch 1/3 addressed,
so looking forward to see v2.

Yours,
Linus Walleij
