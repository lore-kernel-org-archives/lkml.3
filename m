Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3CXSBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 14:01:05 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40101 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3CXSBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 14:01:04 -0400
Message-ID: <514F3F57.5080407@gmail.com>
Date: Sun, 24 Mar 2013 22:00:55 +0400
From: Lijo Antony <lijo.kernel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Peter Hurley <peter@hurleysoftware.com>,
        Ben Skeggs <bskeggs@redhat.com>, Lucas Stach <dev@lynxeye.de>,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>
Subject: Re: [Nouveau] nouveau lockdep splat
References: <20130304211608.GD22274@pd.tnic> <1362501052.1933.2.camel@antimon> <20130319202432.GC4570@pd.tnic> <1363725620.3413.29.camel@thor.lan> <5149589D.6090403@gmail.com> <5149D467.7030908@gmail.com> <20130320152948.GD15471@pd.tnic>
In-Reply-To: <20130320152948.GD15471@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 07:29 PM, Borislav Petkov wrote:
> On Wed, Mar 20, 2013 at 07:23:19PM +0400, Lijo Antony wrote:
>> # bad: [fffddfd6c8e0c10c42c6e2cc54ba880fcc36ebbb] Merge branch
>> 'drm-next' of git://people.freedesktop.org/~airlied/linux
>> git bisect bad fffddfd6c8e0c10c42c6e2cc54ba880fcc36ebbb
>
> This is a merge commit which means something went wrong along the way of
> the bisection.
>

Looks like this has been fixed in -rc4.

-lijo
