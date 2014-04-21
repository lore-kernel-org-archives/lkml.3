Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaDUSS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:18:57 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:33226 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbaDUSSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:18:40 -0400
MIME-Version: 1.0
From: Mike Lothian <mike@fireburn.co.uk>
Date: Mon, 21 Apr 2014 19:18:19 +0100
Message-ID: <CAHbf0-FsLwjMKTHhWX4RY-b3mvAtqpiAmKp9J+edS+sBs8mMag@mail.gmail.com>
Subject: Linking VDSO with ld.gold
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hpa@linux.intel.com, uto@amacapital.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've raised https://bugzilla.kernel.org/show_bug.cgi?id=74391 as I've
been having issues compiling the kernel since
26f5ef2e3c3c18f1dc31461ddf1db00b014edcd4

I'm not sure if linking with ld.gold is officially supported but it
did used to work before this commit and continues to work if I revert
it

Regards

Mike
