Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3CZXej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:34:39 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:45543 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3CZXeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:34:36 -0400
Date: Tue, 26 Mar 2013 16:34:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-serial@vger.kernel.org,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_dw: add support for clk api
Message-ID: <20130326233433.GA31077@kroah.com>
References: <1363689316-7847-2-git-send-email-maxime.ripard@free-electrons.com>
 <1363690369-8067-1-git-send-email-maxime.ripard@free-electrons.com>
 <20130321084707.GB2862@xps8300>
 <515179E6.4020709@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <515179E6.4020709@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 11:35:18AM +0100, Maxime Ripard wrote:
> Hi Greg,
> 
> Le 21/03/2013 09:47, Heikki Krogerus a écrit :
> > On Tue, Mar 19, 2013 at 11:52:49AM +0100, Maxime Ripard wrote:
> >> From: Emilio López <emilio@elopez.com.ar>
> >>
> >> This commit implements support for using the clk api; this lets us use
> >> the "clocks" property with device tree, instead of having to use
> >> clock-frequency.
> >>
> >> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> > 
> > FWIW,
> > 
> > Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> 
> Would you consider merging this patch, or do you have additional comments?
> 
> We have several patch series that depends on this one that I'd like to
> see included in 3.10, and we begin to see the end of the 3.9 release cycle.

You resent one patch, in the middle of a 7 patch series, with me on the
 cc: and somehow expected me to know that I was supposed to apply it?

Please be specific and realistic with your requests.

Resend it if you feel I should apply it.

greg k-h
