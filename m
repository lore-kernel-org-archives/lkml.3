Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3H0Ksp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:48:45 -0400
Received: from ks3293202.kimsufi.com ([5.135.186.141]:46330 "EHLO
	jigen.glandium.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752788Ab3H0Ksn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:48:43 -0400
Date: Tue, 27 Aug 2013 19:48:40 +0900
From: Mike Hommey <mh@glandium.org>
To: linux-kernel@vger.kernel.org
Subject: What could cause siginfo_t.si_addr to always be NULL?
Message-ID: <20130827104840.GA16959@glandium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 182E 161D 1130 B9FC CD7D  B167 E42A A04F A6AA 8C72
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We're running into an interesting issue with Firefox on Android, in
which a segfault signal handler always gets a value of 0 for
siginfo_t.si_addr. The most intesting part is that this only happens on
a few devices/android version combinations. Catching a segfault in gdb
also shows the problem in $_siginfo, which suggests this would be the
kernel doing something weird. Thus my question, what in the kernel could
cause this behavior?

Cheers,

Mike
