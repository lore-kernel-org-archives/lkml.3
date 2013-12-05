Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab3LEPsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:48:36 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:53101 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355Ab3LEPsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:48:35 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 5/5] fat: permit to return phy block number by fibmap in fallocated region
References: <1384688316-3003-1-git-send-email-linkinjeon@gmail.com>
	<87wqjod97k.fsf@devron.myhome.or.jp>
	<CAKYAXd8NS56AYO-EGs4SM9jVn7AfsQbKznxXP2t7Xf2qDXUo1g@mail.gmail.com>
Date: Fri, 06 Dec 2013 00:48:18 +0900
In-Reply-To: <CAKYAXd8NS56AYO-EGs4SM9jVn7AfsQbKznxXP2t7Xf2qDXUo1g@mail.gmail.com>
	(Namjae Jeon's message of "Thu, 5 Dec 2013 23:20:19 +0900")
Message-ID: <8738m7fge5.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> ->i_mutex doesn't work for swapfile.
> Sorry, Actually, I don't understand why it is related with swapfile.
> Could you elaborate more ?

swapfile.c calls ->bmap to know physical address in swapfile. However,
swapfile.c calls ->bmap under inode->i_mutex.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
