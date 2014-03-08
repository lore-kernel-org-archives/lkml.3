Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaCHBys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:54:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbaCHByk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:54:40 -0500
Date: Fri, 7 Mar 2014 22:54:16 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jatania, Neel (Neel)" <Neel.Jatania@alcatel-lucent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Enhancement for PLE handler in KVM
Message-ID: <20140308015416.GA26349@amt.cnet>
References: <530B9637.6030708@alcatel-lucent.com>
 <5314C8C3.3090607@alcatel-lucent.com>
 <5314D61B.9050407@redhat.com>
 <72F5E0D8DB6D83469579E473AD72DB23779EFF64@US70UWXCHMBA01.zam.alcatel-lucent.com>
 <53173961.6080301@redhat.com>
 <72F5E0D8DB6D83469579E473AD72DB23779F1B6B@US70UWXCHMBA01.zam.alcatel-lucent.com>
 <20140307030636.GA13701@amt.cnet>
 <72F5E0D8DB6D83469579E473AD72DB23779F63B3@US70UWXCHMBA01.zam.alcatel-lucent.com>
 <20140307174139.GB30738@amt.cnet>
 <72F5E0D8DB6D83469579E473AD72DB23779F88CA@US70UWXCHMBA01.zam.alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72F5E0D8DB6D83469579E473AD72DB23779F88CA@US70UWXCHMBA01.zam.alcatel-lucent.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 10:08:52PM +0000, Li, Bin (Bin) wrote:
> Fully agree.
> It will be a very helpful feature to make ple setting per VM. 
> This feature will provide more flexible control to the VM user. All KVM user will love to have it.
> 
> The enhancement we proposed is neither overlapping nor conflicting with this feature. The enhancement is targeting to provide the best real time performance to the guest OS.
> There will be more and more embedded system migrating to KVM. Especially in the telecom industry. And a lot of existing system will be running on top of customized embedded OS which significant different from generic OS (either linux  or windows ).

The point Paolo raised is that the hypercall interface can increase CPU 
consumption significantly. It would be good to understand why is
the interface the only way to fix the problem.

> Is there any concern regarding to the enhancement we need to address? Or more work need to be done?

It was not clear from the information you provided that increasing PLE
window alone is not sufficient to reduce clock jitter in the guest 
to acceptable levels (from 400ms to <10ms).

BTW, can you explain the clock jitter measure?

