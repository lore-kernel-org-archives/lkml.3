Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaBZTZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:25:15 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:64295 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaBZTZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:25:13 -0500
MIME-Version: 1.0
From: Ronny Meeus <ronny.meeus@gmail.com>
Date: Wed, 26 Feb 2014 20:24:52 +0100
Message-ID: <CAMJ=MEfz7wkXpXYzpzc171nipkA8ruZGA1KvcX0C6QcKjVcT5A@mail.gmail.com>
Subject: CPULoad measurement
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

My application consists of several hundreds of threads.
I want to create a loadcontrol mechanism at application level so that
when the cpuload of a group of threads crosses a certain
(configurable) threshold, the threads will voluntary yield until the
load condition is over. For this I need to have a mechanism int the
kernel that calculates the consolidated load of each of the
thread-groups.

Is such  a mechanism in place in the kernel?

I could for example define a cgroup per group I want to define and
assign the threads to the correct group. I have no clue whether
internally in the kernel the total CPUload consumed per cgroup is
kept. If that would be the case, it would be ideal.

I do not want to make the sum of all the thread's load (for example
based on the info in the proc filesystem) because this is generating
too much overhead.

Any hint/help/info is much appreciated.

Best regards,
Ronny
