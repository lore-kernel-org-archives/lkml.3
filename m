Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3LULiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 06:38:51 -0500
Received: from verein.lst.de ([213.95.11.211]:59966 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab3LULit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 06:38:49 -0500
Date: Sat, 21 Dec 2013 12:38:45 +0100
From: Torsten Duwe <duwe@lst.de>
To: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
	kernel kexec
Message-ID: <20131221113845.GA9002@lst.de>
References: <20131121191907.GA26366@srcf.ucam.org> <20131122185706.GK4046@redhat.com> <87vbzju6ql.fsf@xmission.com> <20131125163920.GC23094@redhat.com> <87fvqj2vxz.fsf@xmission.com> <20131126142759.GA5473@redhat.com> <20131219125439.GA6379@lst.de> <20131220141917.GB27063@redhat.com> <87a9fvqfs4.fsf@xmission.com> <CAGXu5jKJ88J-++nvkPVvghkXbN+_mB=T1siSDF7yoXQ-d-ONxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKJ88J-++nvkPVvghkXbN+_mB=T1siSDF7yoXQ-d-ONxg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 03:20:16PM -0800, Kees Cook wrote:
> 
> If we're doing fd origin verification (not signatures), can't we
> continue to use a regular bzImage?

I imagine the verification function is separated from the new kexec.
It gets passed the proposed new kernel file*, an optional signature
file*, and maybe hints about the kernel format and system security state.

With that function, you can do whatever you want. If you want to take
an early positive exit due to the location of the new kernel, you're fine.

	Torsten

