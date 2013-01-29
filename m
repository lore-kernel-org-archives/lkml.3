Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3A2CGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:06:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48478 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388Ab3A2CGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:06:05 -0500
Message-ID: <51072E84.4080509@zytor.com>
Date: Mon, 28 Jan 2013 18:05:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 0/2] Secure Boot: More controversial changes
References: <1359391662-26120-1-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1359391662-26120-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 08:47 AM, Matthew Garrett wrote:
> These patches break functionality that people rely on without providing
> any functional equivalent, so I'm not suggesting that they be merged
> as-is. kexec allows trivial circumvention of the trust model (it's
> trivially equivalent to permitting module loading, for instance) and
> hibernation allows similar attacks (disable swap, write a pre-formed resume
> image to swap, reboot). The hibernation patch also shows up a different
> issue - some userspace drops all capabilities, resulting in things that
> userspace expects to work no longer working. This seems like an
> unsurprising result, but breaking userspace is bad and so it'd be nice to
> figure out if there's another way to handle this.

These at the very least need some kind of CONFIG_WEAK_SECURE_BOOT option 
or something like that.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

