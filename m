Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab3FWK0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 06:26:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47831 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab3FWK0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 06:26:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, pavel@ucw.cz, len.brown@intel.com,
        gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCHv v3] power: Include additional information in pm_print_times
Date: Sun, 23 Jun 2013 12:35:31 +0200
Message-ID: <2722061.UXbT4p7DY0@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371982590.3137.32.camel@joe-AO722>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com> <1502403.DSSBonEtkF@vostro.rjw.lan> <1371982590.3137.32.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 23, 2013 03:16:30 AM Joe Perches wrote:
> On Sun, 2013-06-23 at 12:22 +0200, Rafael J. Wysocki wrote:
> > On Sunday, June 23, 2013 03:03:31 AM Joe Perches wrote:
> > > On Sun, 2013-06-23 at 12:07 +0200, Rafael J. Wysocki wrote:
> > > > On Saturday, June 22, 2013 06:05:50 PM Joe Perches wrote:
> > > > > If any script needs something stable it should
> > > > > depend on information available through other
> > > > > sources like trace or proc or sysfs.
> > > > 
> > > > That is clearly impossible in this particular case, though.
> > > 
> > > Why couldn't this printk be converted into an equivalent tracepoint?
> > 
> > Well, why wouldn't you try to do that?
> 
> Why should I?

Because you're arguing that it should be done.

If you think that it's better to use tracepoints here, please implement those
tracepoints and show everyone that they are really better than what we have.

Till then, we'll use what's already there.

Thanks,
Rafael

