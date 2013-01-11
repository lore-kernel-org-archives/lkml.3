Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3AKR06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:26:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab3AKR04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:26:56 -0500
From: Nikola Pajkovsky <npajkovs@redhat.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Lijo Antony <lijo.kernel@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i915_hangcheck_hung problem with 3.8-rc2+ (Linus's latest tree)
In-Reply-To: <50EDCF14.4080101@oracle.com> (Dave Kleikamp's message of "Wed,
	09 Jan 2013 14:12:04 -0600")
References: <20130108223611.GA19672@kroah.com>
	<20130109003824.GA21075@kroah.com>
	<CAPM=9tw3o0e_3cRUFntwddxsWMsYkVKe1b5gDQhxijYKU=9m5g@mail.gmail.com>
	<20130109042533.GA9164@kroah.com>
	<CAPM=9tyB4aKK2Z3-h9yEXLWvrnKGjxH2DaOHp8uA0mNNZQiVWQ@mail.gmail.com>
	<50ED1C12.2090608@gmail.com> <50EDC8A1.30307@oracle.com>
	<50EDCF14.4080101@oracle.com>
User-Agent: Gnus/5.130006 (Ma Gnus v0.6) Emacs/24.2 (x86_64-pc-linux-gnu)
Date: Fri, 11 Jan 2013 18:26:33 +0100
Message-ID: <8738y7skae.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <dave.kleikamp@oracle.com> writes:

> On 01/09/2013 01:44 PM, Dave Kleikamp wrote:
>> 
>> I can easily reproduce it running glxgears on 3.8-rc1 or 3.8-rc2.
>> 
>> 00:02.0 VGA compatible controller [0300]: Intel Corporation Core
>> Processor Integrated Graphics Controller [8086:0046] (rev 02)
>> 
>> Thinkpad T410
>> 
>> Shaggy
>
> Daniel's patch:
>
> drm/i915: Revert shrinker changes from "Track unbound pages"
>
> fixes the problem for me.

bug still kicking even w/ (drm/i915: Revert shrinker changes from "Track
unbound pages")

$ glxgears

[  429.656459] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
[  429.656463] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
[  429.665762] [drm:kick_ring] *ERROR* Kicking stuck wait on render ring

-- 
Nikola
