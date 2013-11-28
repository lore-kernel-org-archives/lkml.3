Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab3K1Ty4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:54:56 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:36593 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3K1Tyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:54:54 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: [PATCHSET PARTIAL REPOST driver-core-next] sysfs: separate out kernfs, take #3
Date: Thu, 28 Nov 2013 14:54:13 -0500
Message-Id: <1385668487-10181-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <20131128060518.GA5291@kroah.com>
References: <20131128060518.GA5291@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

For some reason, quilt can rebase the patches automatically here.  I'm
reposting the rest of the series (patches 07-41) here just in case.
git branches for both pending patchsets are updated accordingly.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-separate-out-kernfs
 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-kernfs-xattr

Thanks.

--
tejun
