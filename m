Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaCGDHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:07:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbaCGDHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:07:30 -0500
Date: Fri, 7 Mar 2014 00:06:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jatania, Neel (Neel)" <Neel.Jatania@alcatel-lucent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "ttracy@redhat.com" <ttracy@redhat.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "riel@redhat.com" <riel@redhat.com>
Subject: Re: Enhancement for PLE handler in KVM
Message-ID: <20140307030636.GA13701@amt.cnet>
References: <53061044.2000009@alcatel-lucent.com>
 <530B9637.6030708@alcatel-lucent.com>
 <5314C8C3.3090607@alcatel-lucent.com>
 <5314D61B.9050407@redhat.com>
 <72F5E0D8DB6D83469579E473AD72DB23779EFF64@US70UWXCHMBA01.zam.alcatel-lucent.com>
 <53173961.6080301@redhat.com>
 <72F5E0D8DB6D83469579E473AD72DB23779F1B6B@US70UWXCHMBA01.zam.alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72F5E0D8DB6D83469579E473AD72DB23779F1B6B@US70UWXCHMBA01.zam.alcatel-lucent.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 09:16:45PM +0000, Li, Bin (Bin) wrote:
> Did you also find out here why this is the case?
> 
> Binl:
> Yes. The application running in our customized embedded OS is also real time application which is timing sensitive. 
> The timing sensitive level varies among the applications.
> When I talking about different threshold, the assumption is using default 4096 ple_window setting.
> If I set up the ple_window to 16384 or higher, there will be no problem for our application. But the finial user could also run linux or window VM on same hypervisor which would prefer default 4096 setting for linux and windows.

Then have per-VM PLE values?

> We are looking for a solution to be good for both linux / window and real time application.
> The enhancement patch we proposed will satisfy both linux/window application and real time embedded applications.
> 
> Paolo


