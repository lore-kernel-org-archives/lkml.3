Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab3FEKRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 06:17:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab3FEKRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 06:17:16 -0400
Date: Wed, 5 Jun 2013 13:17:09 +0300
From: Gleb Natapov <gleb@redhat.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/1] KVM: add kvm_para_available to asm-generic/kvm_para.h
Message-ID: <20130605101709.GV4725@redhat.com>
References: <1369222162-4857-1-git-send-email-james.hogan@imgtec.com>
 <20130604090508.GL4725@redhat.com>
 <CAAG0J98B=TiJXkrK2dF8DaWQjoHwkk+k7CXiN1XJ5VHQFkowFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAG0J98B=TiJXkrK2dF8DaWQjoHwkk+k7CXiN1XJ5VHQFkowFA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 12:33:19PM +0100, James Hogan wrote:
> On 4 June 2013 10:05, Gleb Natapov <gleb@redhat.com> wrote:
> > On Wed, May 22, 2013 at 12:29:22PM +0100, James Hogan wrote:
> >> According to include/uapi/linux/kvm_para.h architectures should define
> >> kvm_para_available, so add an implementation to asm-generic/kvm_para.h
> >> which just returns false.
> >>
> > What is this fixing? The only user of kvm_para_available() that can
> > benefit from this is in sound/pci/intel8x0.c, but I do not see follow up
> > patch to use it there.
> 
> It was an unintentional config with mips + kvm + intel8x0 that hit it
> (I think I accidentally based my mips config off an x86_64 config).
> Kind of equivalent to a randconfig build failure I suppose.
> 
Yes, I see. I will queue the fix. Thanks!

--
			Gleb.
