Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaIBQ4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbaIBQ4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:56:50 -0400
Message-ID: <5405F6C5.1080204@redhat.com>
Date: Tue, 02 Sep 2014 18:56:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Valentine Sinitsyn <valentine.sinitsyn@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
CC: jroedel@suse.de, agraf@suse.de, jan.kiszka@siemens.com,
        gleb@cloudius-systems.com, avi@cloudius-systems.com
Subject: Re: [PATCH 0/4] KVM: nested x86: nested page faults fixes
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com> <5405EA11.7090601@gmail.com>
In-Reply-To: <5405EA11.7090601@gmail.com>
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/09/2014 18:02, Valentine Sinitsyn ha scritto:
>>
> I can confirm the initial bug I observed is fixed with these patches
> (applied to 3.16.1).
> 
> All tests in kvm-unit-test's master also pass, except for ioio which is
> (probably) affected by another (unrelated) bug fixed by Jan back in June
> but not in 3.16 [1,2].
> 
> 1. http://thread.gmane.org/gmane.comp.emulators.kvm.devel/124071/
> 2. http://thread.gmane.org/gmane.comp.emulators.kvm.devel/124067/

Indeed, ioio also hangs for me in 3.16 (not in 3.17).  Thanks, I'll add
your Tested-by.

Paolo
