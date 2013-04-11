Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928Ab3DKVN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:13:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964832Ab3DKVNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:13:22 -0400
Date: Thu, 11 Apr 2013 17:13:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] initramfs with digital signature protection
Message-ID: <20130411211316.GA26587@redhat.com>
References: <1365450229.3847.56.camel@falcor1.watson.ibm.com>
 <20130408200904.GI28292@redhat.com>
 <CA+5PVA43U_kDSV7p0zhQwmK9pwbVb8qAUePU8svQvoPbDA9iCQ@mail.gmail.com>
 <20130409143852.GH6320@redhat.com>
 <1365563230.3074.107.camel@falcor1.watson.ibm.com>
 <20130410194209.GF6602@redhat.com>
 <1365627922.2452.32.camel@falcor1.watson.ibm.com>
 <CACE9dm-GZpjco8u6jNxLQpYA8LYSeoVjsyyRXVwxXHzjO-LvGw@mail.gmail.com>
 <20130411145550.GD21260@redhat.com>
 <CACE9dm-+CY+aLcsrR8CF2TsL26S1wZbYKYS4ropW3ie6tmMZ+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACE9dm-+CY+aLcsrR8CF2TsL26S1wZbYKYS4ropW3ie6tmMZ+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 09:42:54PM +0300, Dmitry Kasatkin wrote:

[..]
> > What other initialization user space need to do where we can't trust
> > root (even in secureboot mode).
> >
> > IOW, if keys can be embedded in kernel (or read from UEFI db and MOK db),
> > what other operation requires initramfs to be signed. It could very well
> > be unsigned initramfs like today.
> >
> 
> It looks like you do not hear me.
> I said that any user space initialization can be done from signed user space.
> For example IMA policy can be initialized.
> 

I am hearing you. Yes I heard you saying  "but perform other initialization,
which requires user-space". I am just trying to figure out more details.
You are assuming that a single line statement gives all the context and it
often might not be the case.

What makes it important that IMA policy is loaded from an signed initramfs
and not from unsigned one.

Also how would you make use of it without secureboot. Only secureboot will
allow to keep keys in firmware so that one can have a key in there and be
able to sign initramfs. 

In regular system, distributions do not ship pre-loaded keys so one can 
not sign initramfs. So only thing possible is that distributions enforce
some policy in signed initramfs and if distributions have to enforce a
policy they can do that in kernel itself and no need for signed initramfs.

Thanks
Vivek
