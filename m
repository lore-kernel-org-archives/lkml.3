Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbaDWJlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:41:15 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:26769 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750860AbaDWJlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:41:13 -0400
Date: Wed, 23 Apr 2014 10:40:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH 04/15] arm64: __NR_compat_syscalls fix
Message-ID: <20140423094034.GA2208@arm.com>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
 <1397211951-20549-5-git-send-email-miklos@szeredi.hu>
 <20140422165814.GH10224@arm.com>
 <CAJfpeguLJjxRu_pktaru9tL3WUo_r=cjmRzqt==M9RkH21GYaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguLJjxRu_pktaru9tL3WUo_r=cjmRzqt==M9RkH21GYaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 09:46:40AM +0100, Miklos Szeredi wrote:
> On Tue, Apr 22, 2014 at 6:58 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > What's your plan with the other patches? Do you submit them as a series
> > or would like the arch maintainers to pick them up?
> 
> Either is OK for me.  I'll collect ACKs for those which the maintainer
> doesn't want to submit, and I'll submit them in one batch.
> 
> But if you have patches anyway, please feel free to pick this up as well.

OK, I took the renameat2 wiring as well. Thanks.

-- 
Catalin
