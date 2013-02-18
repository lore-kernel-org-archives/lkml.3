Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab3BRLJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:09:31 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:37709 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3BRLJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:09:29 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v6 7/7] Documentation: update nfs option in filesystem/vfat.txt
References: <1360422191-12382-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 18 Feb 2013 20:09:27 +0900
In-Reply-To: <1360422191-12382-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 10 Feb 2013 00:03:11 +0900")
Message-ID: <87bobh3ml4.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> -nfs           -- This option maintains an index (cache) of directory
> -		 inodes by i_logstart which is used by the nfs-related code to
> -		 improve look-ups.
> +nfs= stale_rw|nostale_ro

Strange space after nfs=.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
