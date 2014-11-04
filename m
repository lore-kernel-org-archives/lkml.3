Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaKDCZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:25:26 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19156 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686AbaKDCZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:25:21 -0500
Date: Mon, 3 Nov 2014 18:25:45 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: Bjorn Andersson <bjorn@kryo.se>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/6] pinctrl: Introduce pinctrl driver for Qualcomm
 SSBI PMIC's
Message-ID: <20141104022544.GB24501@sonymobile.com>
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
 <1407771634-14946-3-git-send-email-iivanov@mm-sol.com>
 <53F456F3.3000309@linaro.org>
 <20140820212843.GB16274@sonymobile.com>
 <CAJAp7Ojt=PCCDhoR+nhEtQbPHzsp+=uTLx-XMM7-W78bfnQytA@mail.gmail.com>
 <54574177.5030906@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54574177.5030906@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 03 Nov 00:48 PST 2014, Srinivas Kandagatla wrote:

> Hi Bjorn,
> 
> On 20/08/14 23:13, Bjorn Andersson wrote:
> > On Wed, Aug 20, 2014 at 2:28 PM, Bjorn Andersson
> > <bjorn.andersson@sonymobile.com> wrote:
> >> On Wed 20 Aug 01:06 PDT 2014, Srinivas Kandagatla wrote:
> >>> 2> Looking back at v3.4 kernel, for gpio modes, BIT(0) of bank 0 is set
> >>> to enable gpio mode. without this bit driver does not work for output pins.
> >>>
> >>
> >> Thanks, I missed that.
> >>
> >> Unfortunately, setting that bit results in input not working - the interrupt
> >> bits are never set for gpios that have that bit set. I'm trying to figure out
> >> why this is the case before sending out the new version...
> >
> > With help from Andy Gross this is now corrected as well, turned out
> > that BIT(0) in bank0 controls if the "direction" is considered. As I
> > was tricked by the multiple levels of indirection in the codeaurora
> > version I got these wrong.
> >
> > Will send out an updated version shortly.
> Did you get a chance to spin a new version of this patcheset?
> 

Hi Srini,

Unfortunately it ended up on my todo list waiting for a discussion on
irq_read_line(). As this seems to fall in place I will try to get this updated
and sent out.

Sorry for the delays.

Regards,
Bjorn
