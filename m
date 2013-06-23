Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab3FWKlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 06:41:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50998 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750982Ab3FWKlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 06:41:22 -0400
Message-ID: <1371984080.3137.41.camel@joe-AO722>
Subject: Re: [PATCHv v3] power: Include additional information in
 pm_print_times
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Shuah Khan <shuah.kh@samsung.com>, pavel@ucw.cz, len.brown@intel.com,
        gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Sun, 23 Jun 2013 03:41:20 -0700
In-Reply-To: <2722061.UXbT4p7DY0@vostro.rjw.lan>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com>
	 <1502403.DSSBonEtkF@vostro.rjw.lan> <1371982590.3137.32.camel@joe-AO722>
	 <2722061.UXbT4p7DY0@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-23 at 12:35 +0200, Rafael J. Wysocki wrote:
> On Sunday, June 23, 2013 03:16:30 AM Joe Perches wrote:
> > On Sun, 2013-06-23 at 12:22 +0200, Rafael J. Wysocki wrote:
> > > On Sunday, June 23, 2013 03:03:31 AM Joe Perches wrote:
> > > > On Sun, 2013-06-23 at 12:07 +0200, Rafael J. Wysocki wrote:
> > > > > On Saturday, June 22, 2013 06:05:50 PM Joe Perches wrote:
> > > > > > If any script needs something stable it should
> > > > > > depend on information available through other
> > > > > > sources like trace or proc or sysfs.
> > > > > 
> > > > > That is clearly impossible in this particular case, though.
> > > > 
> > > > Why couldn't this printk be converted into an equivalent tracepoint?
> > > 
> > > Well, why wouldn't you try to do that?
> > 
> > Why should I?
>
> Because you're arguing that it should be done.
>
> If you think that it's better to use tracepoints here, please implement those
> tracepoints and show everyone that they are really better than what we have.

Nope, you're arguing that dmesg output, known to be non-stable,
should not have this particular message changed.

You stated "<it's> clearly impossible".  I do dispute that.

If you need something stable, you shouldn't use dmesg,
That's a simple statement, not anything else.

Right now, I don't care if this particular message changes.
I'm not doing any PM testing or timing at the moment.

> Till then, we'll use what's already there.

Fine by me.  It's up to Shuah Khan to get a patch accepted.

cheers, Joe

