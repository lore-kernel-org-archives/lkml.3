Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958Ab3BFFEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:04:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56896 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3BFFEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:04:22 -0500
Message-ID: <5111E44C.2040308@zytor.com>
Date: Tue, 05 Feb 2013 21:04:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
CC: Peter Jones <pjones@redhat.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] initramfs with digital signature protection
References: <cover.1360067333.git.dmitry.kasatkin@intel.com> <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com> <20130205203616.GA8228@fenchurch.internal.datastacks.com> <CALLzPKaTExm=eJ_f4x4NUROk83wDHQy0osexd4QqvHODd9ZPwA@mail.gmail.com>
In-Reply-To: <CALLzPKaTExm=eJ_f4x4NUROk83wDHQy0osexd4QqvHODd9ZPwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 02:09 PM, Kasatkin, Dmitry wrote:
>
> It should not be like that. Actually when pre-init exits, cleanup code
> umount tmpfs, which in turn cleanups the RAM.
>

It doesn't quite... the rootfs is permanent.  This is also only one 
usage mode: there are quite a few Linux systems running directly out of 
initramfs.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

