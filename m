Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3LQRFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 12:05:24 -0500
Received: from relay3.sgi.com ([192.48.152.1]:34402 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753246Ab3LQRFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:05:17 -0500
Message-ID: <52B08446.3080102@sgi.com>
Date: Tue, 17 Dec 2013 11:05:10 -0600
From: Rich Johnston <rjohnston@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>, <viro@zeniv.linux.org.uk>,
        <david@fromorbit.com>, <bpm@sgi.com>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <jack@suse.cz>
CC: Namjae Jeon <namjae.jeon@samsung.com>, <linux-kernel@vger.kernel.org>,
        <xfs@oss.sgi.com>, Ashish Sangwan <a.sangwan@samsung.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH v4 4/10] xfsprog: xfsio: Add support FALLOC_FL_COLLAPSE_RANGE
 for fallocate
References: <1386511890-3794-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1386511890-3794-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [134.15.69.88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch stands alone and has been committed.

Thanks
--Rich

commit ca692f162d36c871c9c1b6169136b2c70503f2d8
Author: Namjae Jeon <namjae.jeon@samsung.com>
Date:   Sun Dec 8 14:11:30 2013 +0000

     xfsprog: xfsio: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
