Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3HBQVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:21:36 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:59519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab3HBQVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:21:35 -0400
Message-ID: <1375460484.18144.11.camel@jlt4.sipsolutions.net>
Subject: Re: Slow firmware timeouts again (Re: [3.11 regression?] iwlwifi
 firmware takes two minutes to load)
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        systemd-devel@lists.freedesktop.org
Date: Fri, 02 Aug 2013 18:21:24 +0200
In-Reply-To: <CALCETrU+C+sO8tJ0X5G4RDVLV=kHQQHurOnEQCoqbAouh60dng@mail.gmail.com> (sfid-20130802_180506_433399_849260E2)
References: <CALCETrU+C+sO8tJ0X5G4RDVLV=kHQQHurOnEQCoqbAouh60dng@mail.gmail.com>
	 (sfid-20130802_180506_433399_849260E2)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 09:04 -0700, Andy Lutomirski wrote:

> > It wasn't exactly fixed and it's really more of a userspace problem - we
> > probably request firmware version 8, and then it takes 30 seconds to
> > time out for each of 8,7,6,5, after which the next request for 4 is
> > successful.
> 
> Why's it requesting those firmwares?  They don't seem to exist on
> intellinuxwireless.org.

Well for one you've never even mentioned what device you have, and then
also it's not requesting 8/7 only 6,5,4 -- I guess the timeout was
increased to 60 seconds (or I'm remembering wrong and it always was? I
thought it was 30s)

johannes

