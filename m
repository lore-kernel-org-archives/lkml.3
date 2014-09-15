Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaIOOZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:25:08 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42807 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaIOOZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:25:04 -0400
Message-ID: <5416F69C.8040905@converseincode.com>
Date: Mon, 15 Sep 2014 07:24:28 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        llvmlinux@lists.linuxfoundation.org, Wim Van Sebroeck <wim@iguana.be>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Charlebois <charlebm@gmail.com>, Rob Clark <robdclark@gmail.com>
Subject: Re: linux-next: manual merge of the llvmlinux tree with the  tree
References: <20140915163813.490886b4@canb.auug.org.au>
In-Reply-To: <20140915163813.490886b4@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/14 23:38, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the llvmlinux tree got a conflict in
> drivers/gpu/drm/msm/hdmi/hdmi.c between commit fc886107c556 ("drm/msm:
> Change nested function to static function") from the watchdog tree and
> commit 8f2c494adad0 ("msm, hdmi: LLVMLinux: Remove nested function from
> HDMI driver") from the llvmlinux tree.
>
> I fixed it up (these patches are doing the same thing, so I used the
> version in the watchdog tree) and can carry the fix as necessary (no
> action is required).
>
> P.S. Behan, I noticed that the llvmlinux patch has no Signed-off-by
> from you even though you committed it ...
Drat. That patch wasn't supposed to be in there. Sorry about that.

Yeah. That one was accepted upstream already. I was carrying it in my 
repos so we could still build until it made it to mainline. I should not 
have put that in linux-next. I actually just had to pull it out of my 
own builds due to the same merge issue.

Hmm. Seems I put a couple of patches into the for-next branch late last 
night which shouldn't have been. Fixed.

Apologies,

Behan

-- 
Behan Webster
behanw@converseincode.com

