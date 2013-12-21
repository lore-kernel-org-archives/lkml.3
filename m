Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3LUDc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 22:32:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50727 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab3LUDc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 22:32:57 -0500
Message-ID: <52B50BBB.9070806@zytor.com>
Date: Fri, 20 Dec 2013 19:32:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Torsten Duwe <duwe@lst.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Peter Jones <pjones@redhat.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
References: <20131121190350.GC17070@kroah.com>	<20131121190620.GA25951@srcf.ucam.org>	<20131121191305.GK16208@redhat.com>	<20131121191907.GA26366@srcf.ucam.org>	<20131122185706.GK4046@redhat.com> <87vbzju6ql.fsf@xmission.com>	<20131125163920.GC23094@redhat.com> <87fvqj2vxz.fsf@xmission.com>	<20131126142759.GA5473@redhat.com> <20131219125439.GA6379@lst.de>	<20131220141917.GB27063@redhat.com> <87a9fvqfs4.fsf@xmission.com>	<52B4D0C6.2000505@zytor.com> <87ioujf0ox.fsf@xmission.com>
In-Reply-To: <87ioujf0ox.fsf@xmission.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 05:32 PM, Eric W. Biederman wrote:
> 
> Stuff and nonsense.  bzImage is just an ugly wrapper around an ELF
> image.
> 

Not really.  We put the ELF image in there to help Xen and presumably
kexec, but there are actually quite a few issues with it... for one
thing, as currently built there are megabytes of zeroes in it for no
good reason.

Even if you don't need the entry code, the additional metadata is
meaningful.

	-hpa


