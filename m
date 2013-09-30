Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3I3Jtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:49:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34010 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab3I3Jtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:49:45 -0400
Date: Mon, 30 Sep 2013 11:49:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>, Andre Przywara <andre@andrep.de>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        libvir-list@redhat.com, Jiri Denemark <jdenemar@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: qemu, numa: non-contiguous cpusets
Message-ID: <20130930094936.GA16383@pd.tnic>
References: <20130929151044.GB5426@pd.tnic>
 <52493EC6.4020403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52493EC6.4020403@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 11:05:10AM +0200, Paolo Bonzini wrote:
> I think there are already patches on the list to do that, as part of
> the NUMA memory binding series from Wanlong Gao.

Yeah: https://lists.gnu.org/archive/html/qemu-devel/2013-09/msg02833.html

Although I don't see from it how the syntax for -cpus will look like
from that QAPI magic except that it is an

+   '*cpus':   ['uint16'],

:-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
