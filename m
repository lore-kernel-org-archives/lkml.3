Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbbAFUTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:19:14 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36223 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbbAFUTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:19:11 -0500
Date: Tue, 6 Jan 2015 21:19:07 +0100
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, David Fries <David@Fries.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] w1: slaves: w1_therm: Add temp attribute
Message-ID: <20150106201906.GA4637@firebird>
References: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
 <1420554596-10250-3-git-send-email-marius.gorski@gmail.com>
 <20150106174221.GA24538@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106174221.GA24538@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 09:42:21AM -0800, Greg Kroah-Hartman wrote:
> On Tue, Jan 06, 2015 at 03:29:56PM +0100, Mariusz Gorski wrote:
> > Add new attribute to simplify reading of current temperature.
> > 
> > Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> > ---
> >  drivers/w1/slaves/w1_therm.c | 32 ++++++++++++++++++++++++++++++++
> >  1 file changed, 32 insertions(+)
> 
> You add sysfs attributes without adding new Documentation/ABI/ entries,
> which means I can't take this patch series, sorry.  Please redo it and
> add the needed information.
> 
> Also, temperature should be a standard sensor attribute, so you might
> want to use that subsystem instead of creating your own ABI here.

Do you mean stuff described in Documentation/thermal/sysfs-api.txt? I am
not exactly sure which subsystem you mean.

> thanks,
> 
> greg k-h

Thanks,
Mariusz
