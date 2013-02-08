Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946363Ab3BHMDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:03:10 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:35162 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946329Ab3BHMDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:03:09 -0500
MIME-Version: 1.0
In-Reply-To: <87pq0bqkod.fsf@sejong.aot.lge.com>
References: <CAJd=RBBvE-5f1UyJGu32EHGVCXe6rVYY0010SKa56j7OvtPG7g@mail.gmail.com>
	<87pq0bqkod.fsf@sejong.aot.lge.com>
Date: Fri, 8 Feb 2013 20:03:06 +0800
Message-ID: <CAJd=RBAgNdXZjcKpJJLwrUUuUpD9Mqmi44etf3HJoA8Xr0iXeQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] stop_machine: dequeue work before signal completion
From: Hillf Danton <dhillf@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Namhyung

On Fri, Feb 8, 2013 at 4:22 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> On Fri, 8 Feb 2013 11:42:43 +0800, Hillf Danton wrote:
>> As checked with BUG_ON in the case of CPU_UP_PREPARE, we have to dequeue
>> work first for further actions, then stopper reaches sane and clear state.
>
> Reviewed-by: Namhyung Kim <namhyung@kernel.org>
>
Double thanks since I did not add you in the cc list, may bad;(

Hillf
