Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3LTXVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:21:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49041 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab3LTXVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:21:30 -0500
Message-ID: <52B4D0C6.2000505@zytor.com>
Date: Fri, 20 Dec 2013 15:20:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>
CC: Torsten Duwe <duwe@lst.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, Peter Jones <pjones@redhat.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
References: <20131121190350.GC17070@kroah.com>	<20131121190620.GA25951@srcf.ucam.org>	<20131121191305.GK16208@redhat.com>	<20131121191907.GA26366@srcf.ucam.org>	<20131122185706.GK4046@redhat.com> <87vbzju6ql.fsf@xmission.com>	<20131125163920.GC23094@redhat.com> <87fvqj2vxz.fsf@xmission.com>	<20131126142759.GA5473@redhat.com> <20131219125439.GA6379@lst.de>	<20131220141917.GB27063@redhat.com> <87a9fvqfs4.fsf@xmission.com>
In-Reply-To: <87a9fvqfs4.fsf@xmission.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 03:11 PM, Eric W. Biederman wrote:
> 
> In that case the chrome folks would simply have to use an ELF format
> kernel and not a bzImage.
> 

This is starting to feel like everything is going in the direction of a
massive feature regression.  bzImage may be weird (it has definitely
grown organically), but the features that have been added to it have
generally been for a reason, e.g. kernel relocation and so on.

	-hpa


