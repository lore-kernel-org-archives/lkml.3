Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaI2VC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 17:02:27 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:32784 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaI2VCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 17:02:25 -0400
MIME-Version: 1.0
In-Reply-To: <1412022964.6334.104.camel@x220>
References: <1411455508-11958-1-git-send-email-valentinrothberg@gmail.com>
	<5421A4B4.1040604@infradead.org>
	<1411492210.30136.15.camel@nebuchadnezzar>
	<5421A9D5.8020503@infradead.org>
	<1411496822.31476.1.camel@nebuchadnezzar>
	<1412021904.6334.97.camel@x220>
	<CAD3Xx4K5hg-sZb5Ek=q=cgPt59+Y8wgAs1iEWOFx2EMcz3EZAg@mail.gmail.com>
	<1412022964.6334.104.camel@x220>
Date: Mon, 29 Sep 2014 14:02:24 -0700
X-Google-Sender-Auth: TJHFEvV_Amv8noB_KUVa1kA_agg
Message-ID: <CAGXu5jKqVospq01gcP1zAbnevipqESA6MkjQ_vbSiYDGC6O9-Q@mail.gmail.com>
Subject: Re: [PATCH] lib: rename TEST_MODULE to TEST_LKM
From: Kees Cook <keescook@chromium.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 1:36 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Mon, 2014-09-29 at 22:25 +0200, Valentin Rothberg wrote:
>> On Mon, Sep 29, 2014 at 10:18 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> > Maybe something like "TEST_MODULE_LOAD"?
>>
>> It has been merged already, see [1]. Sorry, I did not check if you
>> were in the CC to let you know.
>>
>> [1] http://ozlabs.org/~akpm/mmotm/broken-out/lib-rename-test_module-to-test_lkm.patch
>
> That didn't hit lkml, did it? Don't know whether mmotm is set in stone
> nor whether Kees has strong feelings about the name of this feature. (I
> suspect I'm wandering into bicycle shed territory here...).

Oooh! Nope, I hadn't seen this thread. Thanks for CCing me!

I have no problem at all with changing the Kconfig name. I prefer
TEST_LKM over TEST_MODULE_MODULE, FWIW. :)

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
