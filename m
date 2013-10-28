Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab3J1G0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:26:09 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63915 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3J1G0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:26:08 -0400
Date: Sun, 27 Oct 2013 23:26:04 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@ring0.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: N900 DT
Message-ID: <20131028062604.GA1174@teo>
References: <201310240806.49340@pali>
 <201310252039.41026@pali>
 <20131026002500.GA16970@earth.universe>
 <201310261527.25787@pali>
 <20ADAB092842284E95860F279283C5640AA999C5@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20ADAB092842284E95860F279283C5640AA999C5@BGSMSX104.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 03:01:35AM +0000, Tc, Jenny wrote:
> > On Saturday 26 October 2013 02:25:02 Sebastian Reichel wrote:
> > > On Fri, Oct 25, 2013 at 08:39:40PM +0200, Pali Rohár wrote:
> > > > Now I found this patch and it looks like it will be in mainline
> > > > kernel. And after that it could be simple to listen for needed
> > > > events from isp driver in my bq driver (without touching isp).
> > > >
> > > > https://lkml.org/lkml/2013/7/25/204
> > > >
> > > > Can you look at isp1704 driver for DT support? I think that only one
> > > > gpio needs to be passed to driver from board data.
> > >
...
> > What I need is receive property change event (from isp1704) in bq24150a. And with this
> > patch https://lkml.org/lkml/2013/7/25/204
> > bq24150a driver can receive them and use only these which comes from driver specified in
> > DT (on n900 from isp1704).

Pali, Sebastian,

I am OK with that patch. Please send it (of course preserving Jenny's
authorship), along with a user of that notifier and I'll happily apply it.

Thanks,

Anton
