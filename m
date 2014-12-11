Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445AbaLKBi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:38:26 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63422 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758301AbaLKBiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:38:25 -0500
Message-ID: <5488F58B.6050903@redhat.com>
Date: Thu, 11 Dec 2014 02:38:19 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.comp.freedesktop.xorg.drivers.intel,gmane.comp.emulators.kvm.devel,gmane.linux.kernel
To: "Tian, Kevin" <kevin.tian@intel.com>, Gerd Hoffmann <kraxel@redhat.com>,
        "Song, Jike" <jike.song@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Haron, Sandra" <sandra.haron@intel.com>
Subject: Re: [ANNOUNCE][RFC] KVMGT - the implementation of Intel GVT-g(full
 GPU virtualization) for KVM
References: <547FC5DE.4010701@intel.com> <1417769421.11297.37.camel@nilsson.home.kraxel.org> <5481AD24.3000703@redhat.com> <AADFC41AFE54684AB9EE6CBC0274A5D12611365D@SHSMSX101.ccr.corp.intel.com> <54887BD9.7030903@redhat.com> <AADFC41AFE54684AB9EE6CBC0274A5D126116679@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D126116679@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/12/2014 01:33, Tian, Kevin wrote:
> My point is that KVMGT doesn't introduce new requirements as what's
> required in IGD passthrough case, because all the hacks you see now
> is to satisfy guest graphics driver's expectation. I haven't follow up the
> KVM IGD passthrough progress, but if it doesn't require ISA bridge hacking
> the same trick can be adopted by KVMGT too.

Right now it did require ISA bridge hacking.

> You may know Allen is
> working on driver changes to avoid causing those hacks in Qemu side.
> That effort will benefit us too.

That's good to know, thanks!

Paolo
