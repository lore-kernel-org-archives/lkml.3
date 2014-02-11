Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaBKABa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:01:30 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:59671 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaBKAB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:01:27 -0500
MIME-Version: 1.0
In-Reply-To: <52E42B86.1020701@web.de>
References: <52E42B86.1020701@web.de>
Date: Mon, 10 Feb 2014 19:01:26 -0500
X-Google-Sender-Auth: 255piEqhAaRr7WKYFLZiBeQCQhs
Message-ID: <CAJvTdKnt=75AEQhsa8aAdEft7nnySvhxc57_1BHmOS7+tbLeNQ@mail.gmail.com>
Subject: Re: [PATCH] intel_idle: Add CPU model 54 (Atom N2000 series)
From: Len Brown <lenb@kernel.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please send the output of these two command before and after the patch:

dmesg | grep idle
grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*

How did you measure power on the the DN2800MT, and on what workload?

thanks,
-Len Brown, Intel Open Source Technology Center
