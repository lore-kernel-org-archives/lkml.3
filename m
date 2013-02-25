Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab3BYKHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:07:46 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:51741 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab3BYKHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:07:44 -0500
MIME-Version: 1.0
In-Reply-To: <1361778224.4555.163.camel@marge.simpson.net>
References: <CABQ2P6FJBSeuGjQbOEuek6QXkRzRbQMHvsApq4g2-0OGykjKZw@mail.gmail.com>
	<CABQ2P6FVZHWCUogV=xmxv8g-y7RWV_tQqxRMJyxTQK_ixnySjw@mail.gmail.com>
	<1361778224.4555.163.camel@marge.simpson.net>
Date: Mon, 25 Feb 2013 11:07:44 +0100
Message-ID: <CABQ2P6GDQjJPZ-r=OmJxRfwQDjMW63k6AX+_pQFAHvn-xf-7Aw@mail.gmail.com>
Subject: Re: Fwd: Cpu hotplug causes stutter on AMD platform, how can I
 disable it?
From: Mario Giammarco <mgiammarco@gmail.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since ACPI I do not understand anymore who takes decision in my PC. So
you are saying that is not linux kernel but the bios that choose to
powerdown cpus.
Anyway I hope that linux kernel can overtake the bios because
obviously it can take better decisions.
BTW I am seeing in internet that the problem is very very big; I mean
that almost all amd platforms may have this problem. I am suprised
that noone before me informed kernel developers about it.

Thanks again,
Mario

2013/2/25 Mike Galbraith <bitbucket@online.de>:
> On Sun, 2013-02-24 at 22:59 +0100, Mario Giammarco wrote:
>
>> I have searched on internet and I see that is a problem common to
>> several AMD platforms.
>> Even in Microsoft Windows several people have the same problem and
>> they solved it disabling cool&quiet on bios. It seems that some amd
>> cpus on power saving cut off also HT bus blocking data from pcie bus
>> (!?!)
>> I have tried too and infact disabling cool&quiet improves a lot the problem.
>> But I would like to find a better solution, can I disable cpu hotplug?
>> Have you heard of this bug before?
>
> I haven't, but likely others have.  Hm.. if BIOS is shutting down your
> CPUs, I suspect that trying to ignore that in the kernel would be the
> mother of all bad ideas :)
>
> -Mike
>
