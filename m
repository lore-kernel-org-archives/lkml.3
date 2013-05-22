Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab3EVLrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:47:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45632 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3EVLro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:47:44 -0400
Message-ID: <519CB05E.3060903@canonical.com>
Date: Wed, 22 May 2013 13:47:42 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks,
 v3
References: <20130428165914.17075.57751.stgit@patser> <20130428170407.17075.80082.stgit@patser> <20130430191422.GA5763@phenom.ffwll.local> <519CA976.9000109@canonical.com> <20130522113736.GO18810@twins.programming.kicks-ass.net>
In-Reply-To: <20130522113736.GO18810@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 22-05-13 13:37, Peter Zijlstra schreef:
>> Are there any issues left? I included the patch you wrote for injecting -EDEADLK too
>> in my tree. The overwhelming silence makes me think there are either none, or
>> nobody cared enough to review it. :(
> It didn't manage to reach my inbox it seems,.. I can only find a debug
> patch in this thread.
>
Odd, maybe in your spam folder?
It arrived on all mailing lists, so I have no idea why you were left out.

http://www.spinics.net/lists/linux-arch/msg21425.html


~Maarten
