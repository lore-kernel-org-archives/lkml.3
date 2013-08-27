Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3H0Xf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:35:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab3H0Xf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:35:57 -0400
Date: Tue, 27 Aug 2013 16:35:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@ubuntukylin.com>
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@inktank.com>,
        linux-kernel@vger.kernel.org,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH v5] Ceph: Punch hole support for kernel client
Message-Id: <20130827163555.99ef8be3dacd5bd5eadcac8c@linux-foundation.org>
In-Reply-To: <1376538704-6659-1-git-send-email-liwang@ubuntukylin.com>
References: <1376538704-6659-1-git-send-email-liwang@ubuntukylin.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013 11:51:44 +0800 Li Wang <liwang@ubuntukylin.com> wrote:

> This patch implements fallocate and punch hole support for Ceph kernel client.

i386 allmodconfig:

ERROR: "__divdi3" [fs/ceph/ceph.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


Due to a 64-bit divide in ceph_zero_objects()
