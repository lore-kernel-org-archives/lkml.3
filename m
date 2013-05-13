Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3EMUKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:10:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:12783 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab3EMUKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:10:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/CHdlDIYtZj07fZOo4rTyJ+VOrGvPj8kQ=
Date: Mon, 13 May 2013 16:10:15 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: dove: add PMU functions to pinctrl
Message-ID: <20130513201015.GA31290@titan.lakedaemon.net>
References: <1367883368-27889-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130513200002.GY31290@titan.lakedaemon.net>
 <5191472D.7060601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5191472D.7060601@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 10:03:57PM +0200, Sebastian Hesselbarth wrote:
> On 05/13/2013 10:00 PM, Jason Cooper wrote:
> >On Tue, May 07, 2013 at 01:36:08AM +0200, Sebastian Hesselbarth wrote:
> >>Dove power management unit can mux some special functions to mpp0-15.
> >>This patch adds support to set/get the current PMU function mapped
> >>to the corresponding mpp pins. The device tree documentation is also
> >>updated accordingly.
> >>
> >>Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> >
> >Do you intend to have anything depending on these changes in this merge
> >window?
> 
> I don't. There will be pmu and pmic support someday but I am not working
> on it.

Ok, in that case, assuming LinusW is ok with it:

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
