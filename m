Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab3CHKeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:34:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37592 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab3CHKeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:34:12 -0500
Message-ID: <5139BE7F.5020905@zytor.com>
Date: Fri, 08 Mar 2013 02:33:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jingbai Ma <jingbai.ma@hp.com>
CC: Vivek Goyal <vgoyal@redhat.com>, mingo@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        yinghai@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel
 to speedup kernel dump process
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net> <20130307152108.GC2790@redhat.com> <5139B827.3050500@hp.com>
In-Reply-To: <5139B827.3050500@hp.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 02:06 AM, Jingbai Ma wrote:
> 
> Kernel do have some abilities that user space haven't. It's possible to
> map whole memory space of the first kernel into user space on the second
> kernel. But the user space code has to re-implement some parts of the
> kernel memory management system again. And worse, it's architecture
> dependent, more architectures supported, more codes have to be
> implemented. All implementation in user space must be sync to kernel
> implementation. It's may called "flexibility", but it's painful to
> maintain the codes.
> 

What?  You are basically talking about /dev/mem... there is nothing
particularly magic about it at all.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

