Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab3IRC3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 22:29:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45340 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab3IRC3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 22:29:39 -0400
Message-ID: <52390FF8.4080202@zytor.com>
Date: Tue, 17 Sep 2013 19:29:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Geyslan G. Bem" <geyslan@gmail.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Useless inode var and Coding style fixes
References: <1379470942-4084-1-git-send-email-geyslan@gmail.com>
In-Reply-To: <1379470942-4084-1-git-send-email-geyslan@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 07:22 PM, Geyslan G. Bem wrote:
> file size read only one time: useless prior value allocation.
> It's not necessary to verify f_op in the load_aout_library, since the
> prior kernel_read/vfs_read function already does.
> Coding style and printk strings fixes.
> 
> Tested using qemu, a handcrafted a.out binary and a a.out linked with a
> cross-compiled ld.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  fs/binfmt_aout.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)

This is not an x86 patch.

The other one is only because we effectively have a copy of the a.out
code in the ia32 directory, but it too can go through the generic route
with my ack.

	-hpa


