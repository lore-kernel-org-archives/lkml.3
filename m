Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaCGRmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:42:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaCGRl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:41:58 -0500
Date: Fri, 7 Mar 2014 14:41:39 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jatania, Neel (Neel)" <Neel.Jatania@alcatel-lucent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Enhancement for PLE handler in KVM
Message-ID: <20140307174139.GB30738@amt.cnet>
References: <53061044.2000009@alcatel-lucent.com>
 <530B9637.6030708@alcatel-lucent.com>
 <5314C8C3.3090607@alcatel-lucent.com>
 <5314D61B.9050407@redhat.com>
 <72F5E0D8DB6D83469579E473AD72DB23779EFF64@US70UWXCHMBA01.zam.alcatel-lucent.com>
 <53173961.6080301@redhat.com>
 <72F5E0D8DB6D83469579E473AD72DB23779F1B6B@US70UWXCHMBA01.zam.alcatel-lucent.com>
 <20140307030636.GA13701@amt.cnet>
 <72F5E0D8DB6D83469579E473AD72DB23779F63B3@US70UWXCHMBA01.zam.alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72F5E0D8DB6D83469579E473AD72DB23779F63B3@US70UWXCHMBA01.zam.alcatel-lucent.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 02:26:19PM +0000, Li, Bin (Bin) wrote:
> Can we have "per-VM PLE values"?
> 
> My understanding is that the ple values are kvm module setting which applying to all VMs in the system.
> And all vms must be stopped first, then unload kvm-intel, reload kvm-intel with new ple setting.
> 
> /sbin/modprobe -r kvm-intel
> /sbin/modprobe kvm-intel ple_window=16384
> 
> Regards
> Bin

Yes, but it can be made per-VM (its a VMCS field).

