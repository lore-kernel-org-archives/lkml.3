Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab3CQTku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 15:40:50 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:61726 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab3CQTkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 15:40:47 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <201303161135.59793.a.miskiewicz@gmail.com>
References: <201303142136.24917.a.miskiewicz@gmail.com>
	<201303161135.59793.a.miskiewicz@gmail.com>
Date: Sun, 17 Mar 2013 20:40:46 +0100
Message-ID: <CAKMK7uHXpjucZhcjMgZXi2QSXOCgA=NZaOv0m2DvfuyT3TAzRw@mail.gmail.com>
Subject: Re: 3.8.2->3.8.3 i915 regression: GMBUS [i915 gmbus dpb] timed out,
 falling back to bit banging on pin 5
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 11:35 AM, Arkadiusz Miskiewicz
<a.miskiewicz@gmail.com> wrote:
> On Thursday 14 of March 2013, Arkadiusz Miskiewicz wrote:
>> Hello.
>>
>> After upgrading from 3.8.2 to 3.8.3 I'm getting regression :
>
> More people hits this:
> https://bugzilla.redhat.com/show_bug.cgi?id=922304
> https://bugs.archlinux.org/task/34327
> (seems always GM45 gpu in these reports)
>
> archlinux people also noticed that xrandr reports VGA1 as connected (while in
> reality nothing is connected to VGA1)

Can you please test whether 3.9-rc kernels are affected, too? We need
to know this since stable rules mandate that a regression is fixed on
upstream first. Once that's figured out we can backport a fix (if
3.9-rc works) or start working on a fix for 3.8-rc kernels first and
backport afterwards.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
