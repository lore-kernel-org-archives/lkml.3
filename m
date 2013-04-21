Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3DUNXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 09:23:13 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:61782 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3DUNXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 09:23:12 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.125.78]
In-Reply-To: <37C860A02101E749A747FA2D3C1E3C504A4F77@DLEE11.ent.ti.com>
References: <1366133111-5412-1-git-send-email-s-anna@ti.com>
 <CAK=WgbbfT=Ft3GnN1W5A4fg8BDrypgvfeiM3zoRMbW=JS8m+6w@mail.gmail.com> <37C860A02101E749A747FA2D3C1E3C504A4F77@DLEE11.ent.ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 21 Apr 2013 16:22:48 +0300
Message-ID: <CAK=Wgbbqh3ugSj=Gc9bN6a1YgLy2M+EOgTOraC04uB3tT=3Rrg@mail.gmail.com>
Subject: Re: [PATCH 1/2] remoteproc: fix kconfig dependencies for VIRTIO
To: "Anna, Suman" <s-anna@ti.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 6:51 PM, Anna, Suman <s-anna@ti.com> wrote:
>>
>> On Tue, Apr 16, 2013 at 8:25 PM, Suman Anna <s-anna@ti.com> wrote:
>> > remoteproc configuration selects VIRTIO, but VIRTIO is now subordinate
>> > to VIRTUALIZATION. VIRTUALIZATION has to be selected as well to honor
>> > the kconfig menu hierarchy and fix the dependency warnings.
>>
>> Thanks Suman. Is this stable material as well or not relevant before 3.9?
>
> No, it is not applicable before 3.9.

Thanks. We're already at rc7 and it's not urgent, so I plan to push
this when the merge windows opens with cc stable
