Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbaCNVSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:18:05 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:12580 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756309AbaCNVSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:18:00 -0400
Date: Fri, 14 Mar 2014 14:19:53 -0700
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thermal: add generic IIO channel thermal sensor driver
Message-ID: <20140314211952.GJ18578@sonymobile.com>
References: <1391651007-29813-1-git-send-email-courtney.cavin@sonymobile.com>
 <1393484014.2637.14.camel@rzhang1-mobl4>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1393484014.2637.14.camel@rzhang1-mobl4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 07:53:34AM +0100, Zhang Rui wrote:
> On Wed, 2014-02-05 at 17:43 -0800, Courtney Cavin wrote:
> > This driver is a generic method for using IIO ADC channels as thermal
> > sensors.
> > 
> > Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> 
> Eduardo,
> 
> what do you think of this patch?

Apparently not very much.  Oh well.

Sans further input, I will submit a new series with the following
changes:
	- Fix some return values in probe().
	- Change DT binding
		- Submit as seperate patch in series
		- Reword/rename to represent a thermistor
		- Remove specific references to IIO, where appropriate

-Courtney
