Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaBSRpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:45:14 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:4705 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754413AbaBSRpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:45:10 -0500
Date: Wed, 19 Feb 2014 09:46:56 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] usb: chipidea: msm: Add device tree binding
 information
Message-ID: <20140219174655.GN1706@sonymobile.com>
References: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>
 <1392729681-21022-2-git-send-email-iivanov@mm-sol.com>
 <20140218212659.GL1706@sonymobile.com>
 <1392824602.17130.68.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1392824602.17130.68.camel@iivanov-dev>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 04:43:22PM +0100, Ivan T. Ivanov wrote:
> 
> Hi, 
> 
> On Tue, 2014-02-18 at 13:26 -0800, Courtney Cavin wrote: 
> > On Tue, Feb 18, 2014 at 02:21:19PM +0100, Ivan T. Ivanov wrote:
> > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > 
> > > Document device tree binding information as required by
> > > the Qualcomm USB controller.
> > > 
> > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > ---
> > >  .../devicetree/bindings/usb/msm-hsusb.txt          |   17 +++++++++++++++++
> > 
> > Although you mentioned to Josh that this is intended for "non-standard"
> > Chipidea properties, I don't see any other than requiring that 'dr_mode'
> > must be "peripheral".  It would seem that this should all be integrated
> > into a ci3xxx.txt.
> 
> Hm, there is no ci3xxx.txt. The closest match is ci-hdrc-imx.txt.
> So it could be ci-hdrc-qcom.txt or my preferred name qcom,ci-hdrc.txt?

Sorry, I was referring to ci13xxx-imx.txt, which was apparently moved to
ci-hdrc-imx.txt.  I was recommending to merge the two into one
'ci13xxx.txt', as this binding seems to be a new compatible for the same
basic chip.  Now perhaps 'ci-hdrc.txt'.

Although I agree with Josh that this name should be changed, and I think
either of your two suggestions would be acceptable, I would like to at
least discuss the possibility of actually merging the two in this
series.

Comments?

-Courtney
