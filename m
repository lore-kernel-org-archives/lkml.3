Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbaCDNcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:32:17 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:38847 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081AbaCDNcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:32:16 -0500
MIME-Version: 1.0
In-Reply-To: <20140304105421.GA25304@yogesh-Dell-System-XPS-L502X>
References: <20140304105421.GA25304@yogesh-Dell-System-XPS-L502X>
Date: Tue, 4 Mar 2014 14:32:15 +0100
X-Google-Sender-Auth: k_VcW1L5_VcXGsNRPmSGTFszW6I
Message-ID: <CAAsK9AFEdFb8=9CAuqjeScQU4Y1fmuF04GzLTK0Y2tpe3jsZeQ@mail.gmail.com>
Subject: Re: [Patch 1/1] Changes to scripts/checkpatch.pl for improving
 warning messages in case printk usage is detected in a patch
From: Levente Kurusa <levex@linux.com>
To: yogesh <mr.yogesh@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-03-04 11:54 GMT+01:00 yogesh <mr.yogesh@gmail.com>:
> This patch modifies warning message when printk is used in a patch. It mentions to use subsystem_dbg instead of netdev_dbg as the first preffered format of logging debug messages.
Please wrap your changelog at 80 characters a line.
Also, prefered instead of preffered.

> Signed-off-by: Yogesh Chaudhari <mr.yogesh@gmail.com>

Other than that:
Acked-by: Levente Kurusa <levex@linux.com>

Thank you!
> [...]

--
Regards,
Levente Kurusa
