Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaI3P2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:28:31 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5236 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbaI3P2a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:28:30 -0400
Date: Tue, 30 Sep 2014 08:28:39 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Kumar Gala <galak@codeaurora.org>
CC: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v7 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT
 binding
Message-ID: <20140930152838.GN28481@sonymobile.com>
References: <1411428329-23172-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1411428329-23172-2-git-send-email-bjorn.andersson@sonymobile.com>
 <334C6A04-9607-4E97-A7A7-2FEED5986E57@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <334C6A04-9607-4E97-A7A7-2FEED5986E57@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24 Sep 09:39 PDT 2014, Kumar Gala wrote:

> 
> On Sep 22, 2014, at 6:25 PM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:
> 

[..]

> > diff --git a/Documentation/devicetree/bindings/mfd/qcom-rpm.txt b/Documentation/devicetree/bindings/mfd/qcom-rpm.txt

[..]

> > +- qcom,ipc:
> > +     Usage: required
> > +     Value type: <prop-encoded-array>
> > +
> > +     Definition: three entries specifying the outgoing ipc bit used for
> > +                 signaling the RPM:
> > +                 - phandle to a syscon node representing the apcs registers
> > +                 - u32 representing offset to the register within the syscon
> > +                 - u32 representing the ipc bit within the register
> > +
> 
> Does this really ever differ for the SoCs, and even if it does why do we need
> to encode it in DT.  Can’t we determine it via the compatible setting?
> 

The two offsets could be hard coded, especially based on the compatible.

But I don't know if it's worth respinning this just to get those two number out
of here. Also this is now "symmetric" with the smd use cases, where it
shouldn't be hard coded.

Regards,
Bjorn
