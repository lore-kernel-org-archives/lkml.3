Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaBXNBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:01:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37090 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaBXNBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:01:17 -0500
Message-ID: <530B4299.3090508@canonical.com>
Date: Mon, 24 Feb 2014 14:01:13 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Hellstrom <thellstrom@vmware.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        ccross@google.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/6] android: convert sync to fence api, v4
References: <20140217155056.20337.25254.stgit@patser> <20140217155640.20337.13331.stgit@patser> <5304B7F9.4070907@vmware.com>
In-Reply-To: <5304B7F9.4070907@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 19-02-14 14:56, Thomas Hellstrom schreef:
>> >+static void fence_check_cb_func(struct fence *f, struct fence_cb *cb)
>> >+{
>> >+	struct sync_fence_cb *check = container_of(cb, struct sync_fence_cb, cb);
>> >+	struct sync_fence *fence = check->fence;
>> >+
>> >+	// TODO: Add a fence->status member and check it
> Hmm, C++ / C99 style comments makes checkpatch.pl complain. Did you run
> this series through checkpatch?
>
> /Thomas
>
Actually I used c99 here because it shouldn't have been in the sent patch. ;-)

Right below that comment I use fence->status, so the right thing to do was to zap the comment.

Thanks for catching it!

~Maarten\
