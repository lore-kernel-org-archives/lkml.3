Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab3JPWn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:43:28 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:56174 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762117Ab3JPWnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:43:20 -0400
MIME-Version: 1.0
In-Reply-To: <525F083D.8060502@schaufler-ca.com>
References: <20130920203556.GA8726@www.outflux.net>
	<alpine.LRH.2.02.1309241124420.3782@tundra.namei.org>
	<alpine.LRH.2.02.1309241128430.3782@tundra.namei.org>
	<CAGXu5jJ9t7tet4Bx=VUaVmjp1C18iK-nLpQBgmXqgukoAmmd4A@mail.gmail.com>
	<20131016151831.GE5186@outflux.net>
	<201310170547.EHH26015.QOtHJOLFOFVMSF@I-love.SAKURA.ne.jp>
	<525F083D.8060502@schaufler-ca.com>
Date: Wed, 16 Oct 2013 15:43:19 -0700
X-Google-Sender-Auth: CV0NgTXJKhYeUelL8Kxdb0mqSjE
Message-ID: <CAGXu5jLSDynZ_XRZGZ+0uZTgtygO1n8+3rOnR+WonH5-tkui6A@mail.gmail.com>
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
From: Kees Cook <keescook@chromium.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        James Morris <james.l.morris@oracle.com>,
        James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 2:42 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 10/16/2013 1:47 PM, Tetsuo Handa wrote:
>> Kees Cook wrote:
>>> Any update on this? It'd be nice to have it in linux-next.
>> What was the conclusion at LSS about multiple concurrent LSM support?
>> If we agreed to merge multiple concurrent LSM support, there will be nothing to
>> prevent this module from merging.
>>
> Yeah.

The discussion at LSS basically centered around the catch-22 of not
being able to stack, and not having anything to stack (since Yama got
an hard-coded exception). So I sent this LSM as one I'd been waiting
for stacking on. Essentially, I'm breaking the catch-22 by sending
this. I'd like it to get into the tree so we don't have a catch-22
about stacking any more. :)

> The conclusion was that it needs to be staged because it's
> too much to swallow all at once. I can see that. It's going
> to be a lot of work to rearrange and rebase. That's a chunk
> of time I don't expect to have for a while. It looks good
> to happen, but don't hold supper for me.

Do you want me to take a stab at it? It sounds like it was desirable
to cut the current series into two halves? The core changes first, and
the userspace interface changes next?

-Kees

-- 
Kees Cook
Chrome OS Security
