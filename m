Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523Ab3CGViJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:38:09 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:50269 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933501Ab3CGViG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:38:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130307152108.GC2790@redhat.com>
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
	<20130307152108.GC2790@redhat.com>
Date: Thu, 7 Mar 2013 13:38:05 -0800
X-Google-Sender-Auth: p8D0ZEvpuFshHY6g5ZyxjiZAGCE
Message-ID: <CAE9FiQW8nVcNoffm82Wz4B9k1wPWgJuDo3K+a9t10iTFgYhp0Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel to
 speedup kernel dump process
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jingbai Ma <jingbai.ma@hp.com>, mingo@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        hpa@zytor.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 7:21 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Looks like now hpa and yinghai have done the work to be able to load
> kdump kernel above 4GB. I am assuming this also removes the restriction
> that we can only reserve 512MB or 896MB in second kernel.

Yes, From v3.9 and kexec-tools 2.0.4 on x86 64bit.

Thanks

Yinghai
