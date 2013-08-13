Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab3HMGnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:43:37 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:42591 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab3HMGne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:43:34 -0400
MIME-Version: 1.0
In-Reply-To: <1376372927-3510-1-git-send-email-michael@ellerman.id.au>
References: <1376372927-3510-1-git-send-email-michael@ellerman.id.au>
Date: Tue, 13 Aug 2013 09:43:32 +0300
X-Google-Sender-Auth: hzij7EQ5j7jvnV9gYIWdCgMdEg0
Message-ID: <CAOJsxLHb7L8kmnOUGfEjFtQcr1g5B8+WTYxf4nBgR9jor367Kg@mail.gmail.com>
Subject: Re: [PATCH] kvm tools: powerpc: Implement "system-reboot" RTAS call
From: Pekka Enberg <penberg@kernel.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: KVM General <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 8:48 AM, Michael Ellerman
<michael@ellerman.id.au> wrote:
> On some powerpc systems, reboot is implemented by an RTAS call by the
> name of "system-reboot". Currently we don't implement it in kvmtool,
> which means instead the guest prints an error and spins.
>
> This is particularly annoying because when the guest kernel panics it
> will try to reboot, and end up spinning in the guest.
>
> We can't implement reboot properly, ie. causing a reboot, but it's still
> preferable to implement it as halt rather than not implementing it at
> all.
>
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Applied, thanks Michael!
