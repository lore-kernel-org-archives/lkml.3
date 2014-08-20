Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaHTQQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:16:50 -0400
Received: from infra.glanzmann.de ([88.198.249.254]:46342 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaHTQQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:16:48 -0400
Date: Wed, 20 Aug 2014 18:16:45 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION: 8fc5b4d: Unable to compile x86_64 kernel with x86_32
 userland
Message-ID: <20140820161645.GA25390@glanzmann.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Vivek Goyal <vgoyal@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140820060423.GA14660@glanzmann.de>
 <20140820062408.GB14660@glanzmann.de>
 <20140820125630.GA12786@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820125630.GA12786@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

* Vivek Goyal <vgoyal@redhat.com> [2014-08-20 15:53]:
> A patch is sitting in akpm's tree. That patch puts the new code under
> a new config option CONFIG_KEXEC_FILE. So as long as you don't enable
> CONFIG_KEXEC_FILE=y, you should be fine. This should not impact any of
> the existing functionality. Just that you will not get the benefit of
> new system call.

> http://ozlabs.org/~akpm/mmotm/broken-out/kexec-create-a-new-config-option-config_kexec_file-for-new-syscall.patch

> I hope this patch gets merged soon.

> In the mean time I am trying to figure out how can I move away from
> using -mcmodel=large for purgatory.

perfect. I tried the patch and with the patch the kernel compiles again.

Cheers,
        Thomas
