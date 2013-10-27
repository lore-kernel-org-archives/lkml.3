Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab3J0Eaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 00:30:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab3J0Eay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 00:30:54 -0400
Date: Sun, 27 Oct 2013 12:30:23 +0800
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kexec@lists.infradead.org, x86@vger.kernel.org
Subject: query for idea about a kexec regression
Message-ID: <20131027043023.GA18689@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

While I testing efi runtime patches for kexec kernel, there's
2 machines kexec fails on them. It can be reproduced with
non-efi kernel, so it's not related to the patchset.

Problem is kexec kernel will immediatly reboot after below
kernel message:
smpboot: Booting Node   0, Processors  #   1

The latter CPUs were not printed.

nr_cpus=1 works, so there might be some bug on smp code.

Any idea or suspection acout some patches? This is not 100%
reproducible, to me it's about 30% thus it's hard to bisect.

Thanks
Dave
