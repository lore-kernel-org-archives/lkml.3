Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab3AUQmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:42:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab3AUQmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:42:18 -0500
Date: Mon, 21 Jan 2013 11:42:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Message-ID: <20130121164213.GB27617@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
 <871udloiku.fsf@xmission.com>
 <1358312159.4593.37.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358312159.4593.37.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 11:55:59PM -0500, Mimi Zohar wrote:

[..]
> Please remind me why you can't use IMA-appraisal, which was upstreamed
> in Linux 3.7?  Why another method is needed?

So is this IMA-appraisal also supports digital signatures? The IMA white
paper seems to put digital signatures in separate category
(IMA-Appraisal-Signature-Extension).

> 
> With IMA-appraisal, there are a couple of issues that would still need
> to be addressed:
> - missing the ability to specify the validation method required.
> - modify the ima_appraise_tcb policy policy to require elf executables
> to be digitally signed.

For my use case, all executable don't have to be digitally signed. If
something is digitally signed then do the signature verification.

Thanks
Vivek
