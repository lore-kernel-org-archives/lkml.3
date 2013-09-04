Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab3IDUOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:14:04 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:41507 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3IDUOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:14:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130904200959.GE8540@anatevka.fc.hp.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	<1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	<20130904200959.GE8540@anatevka.fc.hp.com>
Date: Wed, 4 Sep 2013 16:14:00 -0400
X-Google-Sender-Auth: UXhIFKiEwJWm9rZzZWQ316e6lUs
Message-ID: <CA+5PVA6HayQJEDFisvXYJKyoKDbJh53fWki=Arbn_9t=NppGrw@mail.gmail.com>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel enforces
 module loading restrictions
From: Josh Boyer <jwboyer@fedoraproject.org>
To: jerry.hoemann@hp.com
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kexec <kexec@lists.infradead.org>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 4:09 PM,  <jerry.hoemann@hp.com> wrote:
> On Tue, Sep 03, 2013 at 07:50:15PM -0400, Matthew Garrett wrote:
>> kexec permits the loading and execution of arbitrary code in ring 0, which
>> is something that module signing enforcement is meant to prevent. It makes
>> sense to disable kexec in this situation.
>>
>> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
>
>
> Matthew,
>
> Disabling kexec will disable kdump, correct?

Yes.

> Are there plans to enable kdump on a system where secure
> boot is enabled?

Vivek Goyal has been working on this.  I've not seen the code yet, but
I believe it should be posted somewhere relatively soon.  We're also
planning on talking about it at the Secure Boot microconference at
Linux Plumbers in two weeks.

josh
