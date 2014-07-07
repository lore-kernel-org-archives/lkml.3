Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaGGHcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 03:32:14 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47054 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaGGHcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 03:32:12 -0400
MIME-Version: 1.0
In-Reply-To: <52823C54.9050208@imgtec.com>
References: <52823C54.9050208@imgtec.com>
Date: Mon, 7 Jul 2014 11:32:12 +0400
Message-ID: <CAMo8Bf+jU3oGn4=6HF=MXMqvVEDDSdtD_pa0u3=4fOXeF5pNUA@mail.gmail.com>
Subject: Re: Release of Linux MTI-3.10-LTS kernel.
From: Max Filippov <jcmvbkbc@gmail.com>
To: "Steven J. Hill" <Steven.Hill@imgtec.com>
Cc: "Linux/MIPS Mailing List" <linux-mips@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 12, 2013 at 6:33 PM, Steven J. Hill <Steven.Hill@imgtec.com> wrote:
> Imagination Technologies is pleased to announce the release of its 3.10 LTS
> (Long-Term Support) MIPS kernel. The changelog below is based off the stable
> Linux 3.10.14 release done by Greg Kroah-Hartman in commit
> 8c15abc94c737f9120d3d4a550abbcbb9be121f6 back on October 1st. The code
> repository is hosted at the Linux/MIPS project GIT:
>
> http://git.linux-mips.org/?p=linux-mti.git;a=summary
>
> We look forward to any comments or feedback.
>
>         The Imagination MIPS Kernel Team
[...]
> Fixes:
> * MIPS HIGHMEM fixes for cache aliasing and non-DMA I/O.

I'm adding HIGHMEM support to xtensa cores with aliasing cache, and found
that the above patch makes generic kmap cache-color aware. Is there a plan
on upstreaming that patch? I can help with upstreaming of the generic part of
it if there's no such plan.

-- 
Thanks.
-- Max
