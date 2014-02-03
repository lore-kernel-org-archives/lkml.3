Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaBCEUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 23:20:07 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:50016 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaBCEUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 23:20:05 -0500
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Feb 2014 23:20:04 EST
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 1/6] fat: add i_disksize to represent uninitialized size
References: <1387953050-2692-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 03 Feb 2014 13:20:01 +0900
In-Reply-To: <1387953050-2692-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Wed, 25 Dec 2013 15:30:50 +0900")
Message-ID: <87ioswx1xq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> Add i_disksize to represent uninitialized allocated size.
> And mmu_private represent initialized allocated size.

Don't we need to update ->i_disksize after cont_write_begin()?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
