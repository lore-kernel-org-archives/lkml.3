Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3FXGuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:50:37 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45579 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3FXGug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:50:36 -0400
MIME-Version: 1.0
In-Reply-To: <878v219ntd.fsf@openvz.org>
References: <1371967656-3150-1-git-send-email-linkinjeon@gmail.com>
	<878v219ntd.fsf@openvz.org>
Date: Mon, 24 Jun 2013 15:50:35 +0900
Message-ID: <CAKYAXd8j9qHbJR6eNK1SDuiiAYpa0ui_EWm1avQYuityw=mhOQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ext4: Add EXT4_IOC_TRUNCATE_BLOCK_RANGE ioctl
From: Namjae Jeon <linkinjeon@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        a.sangwan@samsung.com, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/23, Dmitry Monakhov <dmonakhov@openvz.org>:
> On Sun, 23 Jun 2013 15:07:36 +0900, Namjae Jeon <linkinjeon@gmail.com>
> wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
Hi Dmitry.
> What is the difference between this ioctl and generic punch_hole?
It is different. Dave chinner already answered it.
>>
