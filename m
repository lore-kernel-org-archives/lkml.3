Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3B0Hrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 02:47:40 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42389 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3B0Hri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 02:47:38 -0500
MIME-Version: 1.0
In-Reply-To: <0000013d02ee5bf7-a2d47cfc-64fb-4faa-b92e-e567aeb6b587-000000@email.amazonses.com>
References: <1361550000-14173-1-git-send-email-glommer@parallels.com>
	<alpine.DEB.2.02.1302221034380.7600@gentwo.org>
	<alpine.DEB.2.02.1302221057430.7600@gentwo.org>
	<0000013d02d9ee83-9b41b446-ee42-4498-863e-33b3175c007c-000000@email.amazonses.com>
	<5127A607.3040603@parallels.com>
	<0000013d02ee5bf7-a2d47cfc-64fb-4faa-b92e-e567aeb6b587-000000@email.amazonses.com>
Date: Wed, 27 Feb 2013 09:47:37 +0200
X-Google-Sender-Auth: 3SMNJsywCQnze5C5A97Rhje-9ms
Message-ID: <CAOJsxLFzrw0pCzUG7Ru4dB9=aPoNKHiJ_y3bopiFvBhzV9A5Zg@mail.gmail.com>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 7:23 PM, Christoph Lameter <cl@linux.com> wrote:
> On Fri, 22 Feb 2013, Glauber Costa wrote:
>
>> On 02/22/2013 09:01 PM, Christoph Lameter wrote:
>> > Argh. This one was the final version:
>> >
>> > https://patchwork.kernel.org/patch/2009521/
>> >
>>
>> It seems it would work. It is all the same to me.
>> Which one do you prefer?
>
> Flushing seems to be simpler and less code.

Well, I completely lost track of what to apply... Can someone please
send me the final version that everybody agrees on with proper ACKs
and other attributions?
