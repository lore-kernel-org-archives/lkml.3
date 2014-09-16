Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaIPVIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:08:10 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61161 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaIPVII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:08:08 -0400
MIME-Version: 1.0
In-Reply-To: <1410899363-27635-1-git-send-email-zlim.lnx@gmail.com>
References: <1410892655-17818-1-git-send-email-zlim.lnx@gmail.com>
	<1410899363-27635-1-git-send-email-zlim.lnx@gmail.com>
Date: Tue, 16 Sep 2014 14:08:07 -0700
Message-ID: <CAMEtUuzXquYHBOE3Rftag=u7Duct=yT5KYJ3_2Jhg2K0sfS4EQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: bpf: add 'load 64-bit immediate' instruction
From: Alexei Starovoitov <ast@plumgrid.com>
To: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 1:29 PM, Zi Shen Lim <zlim.lnx@gmail.com> wrote:
> Hi Catalin, Will,
>
> Please consider applying this after -rc1 as well. [1]

Thank you for adding support of these instructions.
I don't have any new ones in pipeline, so we should be done
for foreseeable future :)

Both patches look good to me and I don't see anything
scary in them, so should be ok as soon as both trees merge.
