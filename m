Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab3FWKDg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 06:03:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37794 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750883Ab3FWKDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 06:03:32 -0400
Message-ID: <1371981811.3137.25.camel@joe-AO722>
Subject: Re: [PATCHv v3] power: Include additional information in
 pm_print_times
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Shuah Khan <shuah.kh@samsung.com>, pavel@ucw.cz, len.brown@intel.com,
        gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Sun, 23 Jun 2013 03:03:31 -0700
In-Reply-To: <2168940.loyeqX9NTF@vostro.rjw.lan>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com>
	 <2732229.sfB5fHUFTc@vostro.rjw.lan> <1371949550.3137.16.camel@joe-AO722>
	 <2168940.loyeqX9NTF@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-23 at 12:07 +0200, Rafael J. Wysocki wrote:
> On Saturday, June 22, 2013 06:05:50 PM Joe Perches wrote:
> > If any script needs something stable it should
> > depend on information available through other
> > sources like trace or proc or sysfs.
> 
> That is clearly impossible in this particular case, though.

Why couldn't this printk be converted into an equivalent tracepoint?


