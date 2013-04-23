Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3DWHNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:13:37 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:36142 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3DWHNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:13:35 -0400
X-Greylist: delayed 1153 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Apr 2013 03:13:35 EDT
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v5] fat: editions to support fat_fallocate
References: <1366293255-4649-1-git-send-email-linkinjeon@gmail.com>
	<20130422150302.d01a3edb005a79bd68929d38@linux-foundation.org>
	<CAKYAXd8PwvExNJ9VruuuTp15PLijzWfZAjC85L6_9GsdMB+TfA@mail.gmail.com>
Date: Tue, 23 Apr 2013 15:54:14 +0900
In-Reply-To: <CAKYAXd8PwvExNJ9VruuuTp15PLijzWfZAjC85L6_9GsdMB+TfA@mail.gmail.com>
	(Namjae Jeon's message of "Tue, 23 Apr 2013 14:33:59 +0900")
Message-ID: <874nexwxd5.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> BTW, I don't intend to send this patch into Linus until I have
>> heard from hirofumi.  Please let me know if he has already reviewed
>> and acked it?
> Thanks Andrew for updating.
> We do not have ACK mail from OGAWA yet, even though he reviewed but
> final ACK is pending.
> And we will send updated one v5 patch with your change soon.

Sorry for so long late. This is not simple one, rather complex, and we
have to confirm we never expose uninitialized data.

To confirm it, I will try to make a bunch of time for next weekend.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
