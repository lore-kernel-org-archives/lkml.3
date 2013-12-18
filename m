Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3LRKmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:42:45 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60785 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3LRKmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:42:43 -0500
MIME-Version: 1.0
In-Reply-To: <20131218091609.GB14274@lee--X1>
References: <CAOMwXhN5UfR=Y8V3i=A2zSCv7V9sRDd0Z+D1AQFahvRS-mV5Fw@mail.gmail.com>
	<20131216082556.GE18769@lee--X1>
	<CAOMwXhN8fG8YbU53A_U_MyMTyGWfV7NCCtr2a5oCbHdB0iqqmA@mail.gmail.com>
	<20131216150514.GN18769@lee--X1>
	<CAOMwXhMn5W76Dp=EFNHaknXCqZ4q4e7fphgtttx+8U=1Fc_DMQ@mail.gmail.com>
	<20131216164844.GS18769@lee--X1>
	<CAOMwXhPLNVKbRqR2tPQc758zLsh0Lg0D6JUf2yrf+ZosJVANAw@mail.gmail.com>
	<20131218091609.GB14274@lee--X1>
Date: Wed, 18 Dec 2013 10:42:42 +0000
X-Google-Sender-Auth: I7WPgfc7RtG3LyziEmCoQeSjggc
Message-ID: <CAOMwXhOSpnEiDoyXNPmy0Gt1tLiwdzGRqoseKqtAUogLEfkCZQ@mail.gmail.com>
Subject: Re: Simple MFD driver example
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX6650/6651 chip has multiple functionality:

* fan/hwmon

* gpio

* alarm, etc.

What you eventually see in hwmon is only a subset of all the features
the IC provides. You may want to read this thread:
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg536509.html
