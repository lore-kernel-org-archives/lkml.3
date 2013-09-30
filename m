Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3I3MSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 08:18:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab3I3MSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 08:18:13 -0400
Message-ID: <52496BFD.4030809@redhat.com>
Date: Mon, 30 Sep 2013 14:18:05 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Eduardo Habkost <ehabkost@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>, Andre Przywara <andre@andrep.de>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        libvir-list@redhat.com, Jiri Denemark <jdenemar@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: qemu, numa: non-contiguous cpusets
References: <20130929151044.GB5426@pd.tnic> <52493EC6.4020403@redhat.com> <20130930094936.GA16383@pd.tnic>
In-Reply-To: <20130930094936.GA16383@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/09/2013 11:49, Borislav Petkov ha scritto:
> Yeah: https://lists.gnu.org/archive/html/qemu-devel/2013-09/msg02833.html
> 
> Although I don't see from it how the syntax for -cpus will look like
> from that QAPI magic except that it is an
> 
> +   '*cpus':   ['uint16'],

It's "-numa node,cpus=0-1,cpus=4-5".

Paolo
