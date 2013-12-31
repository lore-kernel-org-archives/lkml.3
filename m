Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3LaJyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 04:54:44 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:34992 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3LaJyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 04:54:43 -0500
MIME-Version: 1.0
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 31 Dec 2013 15:24:00 +0530
Message-ID: <CALkWK0n0q+a9EmMbJXsgo6eO1B+0Lq6tqsN3moLbXz+Y0GGu0g@mail.gmail.com>
Subject: [QUERY] Power consumption on a 2013 MBP
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On a 2013 Macbook Pro, Linux consumes 21W of power while OS X consumes
just 9W. I found this very disturbing; Linux more than halves the
battery life of the device. I checked to see that I wasn't running any
especially power-hungry applications or drivers (using powertop). I'm
using just one proprietary driver: the broadcom-wl wireless driver;
otherwise, I'm running the stock 3.12 kernel from Arch's repositories.

How do I figure out what is consuming power, and what can I do to help
minimize consumption?

Thanks.

Ram
