Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbbAFU0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:26:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbAFU0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:26:17 -0500
Date: Tue, 6 Jan 2015 12:26:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, David Fries <David@Fries.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] w1: slaves: w1_therm: Add temp attribute
Message-ID: <20150106202616.GB15277@kroah.com>
References: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
 <1420554596-10250-3-git-send-email-marius.gorski@gmail.com>
 <20150106174221.GA24538@kroah.com>
 <20150106201906.GA4637@firebird>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106201906.GA4637@firebird>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 09:19:07PM +0100, Mariusz Gorski wrote:
> On Tue, Jan 06, 2015 at 09:42:21AM -0800, Greg Kroah-Hartman wrote:
> > On Tue, Jan 06, 2015 at 03:29:56PM +0100, Mariusz Gorski wrote:
> > > Add new attribute to simplify reading of current temperature.
> > > 
> > > Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> > > ---
> > >  drivers/w1/slaves/w1_therm.c | 32 ++++++++++++++++++++++++++++++++
> > >  1 file changed, 32 insertions(+)
> > 
> > You add sysfs attributes without adding new Documentation/ABI/ entries,
> > which means I can't take this patch series, sorry.  Please redo it and
> > add the needed information.
> > 
> > Also, temperature should be a standard sensor attribute, so you might
> > want to use that subsystem instead of creating your own ABI here.
> 
> Do you mean stuff described in Documentation/thermal/sysfs-api.txt?

Yes, that is the one.

