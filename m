Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbbAFQML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:12:11 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61847 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbbAFQMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:12:10 -0500
Date: Tue, 6 Jan 2015 17:12:05 +0100
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, David Fries <David@fries.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] w1: slaves: w1_therm: Add sysfs entry for current
 temperature
Message-ID: <20150106161205.GA2912@firebird>
References: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
 <CAFLxGvwXN0XKQ_fX7pS=dpZf+SoysN_fH8iAgtyMYG9dX+6oAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvwXN0XKQ_fX7pS=dpZf+SoysN_fH8iAgtyMYG9dX+6oAQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 04:01:47PM +0100, Richard Weinberger wrote:
> On Tue, Jan 6, 2015 at 3:29 PM, Mariusz Gorski <marius.gorski@gmail.com> wrote:
> > DS18B20 and it's brothers are pretty popular in the RaspberryPi world
> > when it comes to temperature measurement. All tutorials on the Internet
> > use the same way of parsing the output of the w1_slave sysfs file.
> > These patches add a dedicated sysfs entry called 'temp' whose only job
> > is to output the current temperature.
> 
> And what is the benefit of this patches?

Well, instead of having to parse the output of w1_slave:

$ cat w1_slave 
4d 01 55 00 7f ff 0c 10 fd : crc=fd YES
4d 01 55 00 7f ff 0c 10 fd t=20812

the userspace program gets only the interesting information,
which usually is the current temparture:

$ cat temp 
20812

> 
> -- 
> Thanks,
> //richard
