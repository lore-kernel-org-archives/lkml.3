Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaHEW7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 18:59:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53970 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbaHEW7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 18:59:34 -0400
Message-ID: <1407279569.2170.18.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PULL] fw-restrict update (3.17)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>
Date: Tue, 05 Aug 2014 18:59:29 -0400
In-Reply-To: <CAGXu5jK--17NZvJK2BSWiANn4dkgLMUpGpoWrmy+jM=BfKkBxQ@mail.gmail.com>
References: <20140725185048.GA27939@www.outflux.net>
	 <CAGXu5jK--17NZvJK2BSWiANn4dkgLMUpGpoWrmy+jM=BfKkBxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080522-6688-0000-0000-000003CB0E18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-05 at 14:46 -0700, Kees Cook wrote: 
> On Fri, Jul 25, 2014 at 11:50 AM, Kees Cook <keescook@chromium.org> wrote:
> > Hi James,
> >
> > Please pull these fw-restrict changes for 3.17. Thanks!
> 
> James, did this ever get pulled? Does it need more review?
> 
> Thanks!
> 

They made it to the linux-security tree: 
6593d92 firmware_class: perform new LSM checks

$ git branch -r --contains 6593d92
  dhowells-fs/keys-next
  kees/for-security-next-fw-restrict
  linux-next/akpm
  linux-next/akpm-base
  linux-next/master
  origin/next          <=== linux-security

Mimi

