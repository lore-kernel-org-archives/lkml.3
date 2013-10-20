Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab3JTK2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 06:28:38 -0400
Received: from venus.codepro.be ([5.9.86.228]:13173 "EHLO venus.codepro.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab3JTK2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 06:28:37 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Oct 2013 06:28:37 EDT
Date: Sun, 20 Oct 2013 12:22:03 +0200
From: Kristof Provost <kristof@sigsegv.be>
To: jiaweiwei <jiaweiwei.xiyou@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Subject: Re: [RFC] Rollback FS
Message-ID: <20131020102203.GB77546@vega.codepro.be>
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
X-PGP-Fingerprint: E114 D9EA 909E D469 8F57  17A5 7D15 91C6 9EFA F286
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-10-20 15:06:33 (+0800), jiaweiwei <jiaweiwei.xiyou@gmail.com> wrote:
> We could implement a File System to record all the operations which
> send to VFS. Then when you think you have done a mistake command, you
> could rollback from this File System.
> 
> This is just a RFC, I would give detail implementations. Would anyone
> please give me some suggestions? Thanks very much.

I think it needs to be fleshed out a lot more.

For example, how would you tell it to roll back without a functional
libc? How does it differ from the snapshot feature in btrfs?

Regards,
Kristof
