Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764788Ab3DDUTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:19:23 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:45853 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764765Ab3DDUTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <515DDEC0.9000109@zytor.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
	<1365106055-22939-4-git-send-email-keescook@chromium.org>
	<515DDEC0.9000109@zytor.com>
Date: Thu, 4 Apr 2013 13:19:21 -0700
Message-ID: <CAKyRK=iZeYv8MPa2tLfRRTmNX2WQsT+t3UAu_wy3uT9TiZokgA@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
From: Julien Tinnes <jln@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 1:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/04/2013 01:07 PM, Kees Cook wrote:
>> However, the benefits of
>> this feature in certain environments exceed the perceived weaknesses[2].
>
> Could you clarify?

I think privilege reduction in general, and sandboxing in particular,
can make KASLR even more useful. A lot of the information leaks can be
mitigated in the same way as attack surface and vulnerabilities can be
mitigated.

Julien
