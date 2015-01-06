Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbbAFPBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:01:49 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:61616 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbbAFPBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:01:48 -0500
MIME-Version: 1.0
In-Reply-To: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
References: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
Date: Tue, 6 Jan 2015 16:01:47 +0100
Message-ID: <CAFLxGvwXN0XKQ_fX7pS=dpZf+SoysN_fH8iAgtyMYG9dX+6oAQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] w1: slaves: w1_therm: Add sysfs entry for current temperature
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, David Fries <David@fries.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 3:29 PM, Mariusz Gorski <marius.gorski@gmail.com> wrote:
> DS18B20 and it's brothers are pretty popular in the RaspberryPi world
> when it comes to temperature measurement. All tutorials on the Internet
> use the same way of parsing the output of the w1_slave sysfs file.
> These patches add a dedicated sysfs entry called 'temp' whose only job
> is to output the current temperature.

And what is the benefit of this patches?

-- 
Thanks,
//richard
