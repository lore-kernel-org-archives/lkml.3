Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaIBQCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:02:35 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:61390 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaIBQCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:02:31 -0400
Message-ID: <5405EA11.7090601@gmail.com>
Date: Tue, 02 Sep 2014 22:02:25 +0600
From: Valentine Sinitsyn <valentine.sinitsyn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
CC: jroedel@suse.de, agraf@suse.de, jan.kiszka@siemens.com,
        gleb@cloudius-systems.com, avi@cloudius-systems.com
Subject: Re: [PATCH 0/4] KVM: nested x86: nested page faults fixes
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=koi8-r; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,

On 02.09.2014 21:13, Paolo Bonzini wrote:
> Patches 3 and 4 fix the interaction between emulator and nested EPT/NPT,
> which was reported by Valentine.
I can confirm the initial bug I observed is fixed with these patches 
(applied to 3.16.1).

All tests in kvm-unit-test's master also pass, except for ioio which is 
(probably) affected by another (unrelated) bug fixed by Jan back in June 
but not in 3.16 [1,2].

1. http://thread.gmane.org/gmane.comp.emulators.kvm.devel/124071/
2. http://thread.gmane.org/gmane.comp.emulators.kvm.devel/124067/

Thanks,
Valentine
