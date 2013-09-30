Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3I3QTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:19:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55725 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab3I3QTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:19:04 -0400
Date: Mon, 30 Sep 2013 18:18:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre@andrep.de>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        libvir-list@redhat.com, Jiri Denemark <jdenemar@redhat.com>
Subject: Re: [PATCH 1/6] kvm: Add KVM_GET_EMULATED_CPUID
Message-ID: <20130930161856.GC16383@pd.tnic>
References: <20130923162856.GC7264@otherpad.lan.raisama.net>
 <2f5d83d4d90ba9c5930f099d6f73e61b.squirrel@www.skyhub.de>
 <20130924100414.GE17294@redhat.com>
 <20130926141915.GV2840@otherpad.lan.raisama.net>
 <20130926185524.GA10123@pd.tnic>
 <20130926192059.GD10924@otherpad.lan.raisama.net>
 <20130926203206.GB10123@pd.tnic>
 <20130927142100.GB2840@otherpad.lan.raisama.net>
 <20130928104903.GB5956@pd.tnic>
 <20130930161334.GA5831@otherpad.lan.raisama.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130930161334.GA5831@otherpad.lan.raisama.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 01:13:34PM -0300, Eduardo Habkost wrote:
> I have added it to my TODO-list.  :-)

Cool, thanks. Let me know if I can test stuff and help out somehow.

> > 
> > Also, there's another aspect, while we're here: now that QEMU emulates
> > MOVBE with TCG too, how do we specify on the command line, which
> > emulation should be used - kvm.ko or QEMU?
> 
> You can use accel={tcg,kvm} option on the "-machine" argument, e.g.
> "-machine pc,accel=kvm". Or the "-enable-kvm" option.

Ah, ok.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
