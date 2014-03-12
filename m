Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaCLNF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:05:27 -0400
Received: from ihemail3.lucent.com ([135.245.0.37]:46949 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaCLNFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:05:20 -0400
Message-ID: <53205B87.1080508@alcatel-lucent.com>
Date: Wed, 12 Mar 2014 09:05:11 -0400
From: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130809 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jatania, Neel (Neel)" <Neel.Jatania@alcatel-lucent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Enhancement for PLE handler in KVM
References: <530B9637.6030708@alcatel-lucent.com> <5314C8C3.3090607@alcatel-lucent.com> <5314D61B.9050407@redhat.com> <72F5E0D8DB6D83469579E473AD72DB23779EFF64@US70UWXCHMBA01.zam.alcatel-lucent.com> <53173961.6080301@redhat.com> <72F5E0D8DB6D83469579E473AD72DB23779F1B6B@US70UWXCHMBA01.zam.alcatel-lucent.com> <20140307030636.GA13701@amt.cnet> <72F5E0D8DB6D83469579E473AD72DB23779F63B3@US70UWXCHMBA01.zam.alcatel-lucent.com> <20140307174139.GB30738@amt.cnet> <72F5E0D8DB6D83469579E473AD72DB23779F88CA@US70UWXCHMBA01.zam.alcatel-lucent.com> <20140308015416.GA26349@amt.cnet> <531F19D7.6030909@alcatel-lucent.com> <531F364C.5020406@redhat.com>
In-Reply-To: <531F364C.5020406@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [135.5.27.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Paolo for the comments

Understand the requirement to "fix it for all guest OSes".

I will investigate the "new hypercall KVM_HC_HALT_AND_YIELD_TO_CPU that 
takes an APIC id, donates the quantum to that CPU, and puts the 
originating CPU in halted state. "

Regards
Bin

