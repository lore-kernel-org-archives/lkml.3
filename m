Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3LAMXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 07:23:05 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:51454 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3LAMXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 07:23:02 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: add i_disksize to represent uninitialized size
References: <1384688265-2866-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 01 Dec 2013 21:22:50 +0900
In-Reply-To: <1384688265-2866-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 17 Nov 2013 20:37:45 +0900")
Message-ID: <87eh5wep5x.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>  	/* NOTE: mmu_private is 64bits, so must hold ->i_mutex to access */
> -	loff_t mmu_private;	/* physically allocated size */
> +	loff_t mmu_private;	/* physically allocated size (uninitialized) */
> +	loff_t i_disksize;	/* physically allocated size (initialized) */

comment is correct? (iirc, mmu_private is initialized)
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
