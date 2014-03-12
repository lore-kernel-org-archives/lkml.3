Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaCLWwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:52:03 -0400
Received: from www84.your-server.de ([213.133.104.84]:55108 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaCLWwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:52:00 -0400
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 0/3] Improve 32 bit vDSO time
Date: Wed, 12 Mar 2014 23:51:17 +0100
Message-Id: <1394664680-17799-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch bring some improvments to the vDSO 32 bit:

- undef some kernel configs which increase the code size of the VDSO
- remove vsyscall and prevent wrong conditional VVAR_PAGE mapping
- handle VDSO larger than a page

The patch set is agains tip 7ed5ee279499a02bf35c77f0a91d657c24f6474e
