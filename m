Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3JVPU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:20:58 -0400
Received: from relay3.sgi.com ([192.48.152.1]:41447 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752262Ab3JVPU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:20:57 -0400
Message-ID: <526697FD.1090406@sgi.com>
Date: Tue, 22 Oct 2013 10:21:33 -0500
From: Rich Johnston <rjohnston@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Namjae Jeon <linkinjeon@gmail.com>, <viro@zeniv.linux.org.uk>,
        <mtk.manpages@gmail.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <bpm@sgi.com>, <elder@kernel.org>, <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>, <linux-kernel@vger.kernel.org>,
        <xfs@oss.sgi.com>, <a.sangwan@samsung.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH RESEND 4/7] xfsprogs: xfsio: add support FALLOC_FL_COLLAPSE_RANGE
 for fallocate
References: <1381090418-2829-1-git-send-email-linkinjeon@gmail.com> <52616EC6.7030400@sgi.com> <20131018224404.GX4446@dastard>
In-Reply-To: <20131018224404.GX4446@dastard>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit was reverted

commit 19e73c9d220728617816c47a1671cc931c40e45b
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Tue Oct 22 10:15:20 2013 -0500

     Revert "[RESEND, 4/7] xfsprogs: xfsio: add support 
FALLOC_FL_COLLAPSE_RANGE for fallocate"

     This reverts commit e64190f8440286a815060524777b435e06a7b364 until we
     have the fallocate API support merged into the kernel. The kernel
     code is still under review.

