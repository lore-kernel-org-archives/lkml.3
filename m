Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3B0KX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:23:28 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:56800 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3B0KX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:23:26 -0500
MIME-Version: 1.0
In-Reply-To: <20130227101906.GB1924@cantiga.alporthouse.com>
References: <20130226235912.881663118@linuxfoundation.org>
	<20130226235918.530615135@linuxfoundation.org>
	<CAMeQTsadxx_hEkJ0Jd5wHp2UNERh1+c5Z-VV-Zi4=xz=VJ3d+A@mail.gmail.com>
	<20130227101906.GB1924@cantiga.alporthouse.com>
Date: Wed, 27 Feb 2013 11:23:24 +0100
Message-ID: <CAMeQTsbWO=7bWRsYR16i7orcudcA+_Fk9AKqPUxCZMfvDgzFOQ@mail.gmail.com>
Subject: Re: [ 54/86] drm/i915: Set i9xx sdvo clock limits according to specifications
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 11:19 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, Feb 27, 2013 at 11:11:38AM +0100, Patrik Jakobsson wrote:
>> On Wed, Feb 27, 2013 at 1:08 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > 3.4-stable review patch.  If anyone has any objections, please let me know.
>> >
>> > ------------------
>> >
>> > From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
>> >
>> > commit 4f7dfb6788dd022446847fbbfbe45e13bedb5be2 upstream.
>
>> Is this really stable material? It fixes no known issues and the bug
>> report seems to be a different problem.
>
> https://bugs.freedesktop.org/show_bug.cgi?id=59066 is a genuine bug
> fixed.
> -Chris

Great, then I have no problems with this going in.
-Patrik
