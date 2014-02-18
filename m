Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaBRR2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:28:25 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:52849 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbaBRR2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:28:22 -0500
Message-ID: <1392744420.17130.24.camel@iivanov-dev>
Subject: Re: [PATCH v2 1/3] usb: chipidea: msm: Add device tree binding
 information
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Tue, 18 Feb 2014 19:27:00 +0200
In-Reply-To: <20140218161303.GD31116@joshc.qualcomm.com>
References: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>
	 <1392729681-21022-2-git-send-email-iivanov@mm-sol.com>
	 <20140218161303.GD31116@joshc.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Tue, 2014-02-18 at 10:13 -0600, Josh Cartwright wrote: 
> On Tue, Feb 18, 2014 at 03:21:19PM +0200, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > Document device tree binding information as required by
> > the Qualcomm USB controller.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  .../devicetree/bindings/usb/msm-hsusb.txt          |   17 +++++++++++++++++
> 
> Is this really the appropriate place to document this?  It seems like
> this binding doc should be merged with the i.MX ci13xxx binding in a
> common ci13xxx doc.
> 

This driver is a "glue" layer driver which control Qualcomm 
specific logic around Chipidea IP core. It is supposed to 
hold "non standard" Chipidea properties, but I suppose that
ci-hdrc-qcom.txt will be better name and will be similar to 
i.MX chosen name.


What do you think?

Regards,
Ivan

