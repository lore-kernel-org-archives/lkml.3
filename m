Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764718Ab3DDUN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:13:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57284 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764485Ab3DDUN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:13:28 -0400
Message-ID: <515DDEC0.9000109@zytor.com>
Date: Thu, 04 Apr 2013 13:12:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1365106055-22939-4-git-send-email-keescook@chromium.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 01:07 PM, Kees Cook wrote:
> However, the benefits of
> this feature in certain environments exceed the perceived weaknesses[2].

Could you clarify?

	-hpa


