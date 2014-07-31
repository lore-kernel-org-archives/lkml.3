Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaGaQdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:33:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaGaQda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:33:30 -0400
Message-ID: <53DA6FBE.1020500@redhat.com>
Date: Thu, 31 Jul 2014 18:33:02 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, kvm@vger.kernel.org,
        mtosatti@redhat.com
Subject: Re: [PATCH 1/2] x86: AMD: mark TSC unstable on APU family 15h models
 10h-1fh
References: <1406800033-13404-1-git-send-email-imammedo@redhat.com> <1406800033-13404-2-git-send-email-imammedo@redhat.com> <20140731154747.GA7160@pd.tnic>
In-Reply-To: <20140731154747.GA7160@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/07/2014 17:47, Borislav Petkov ha scritto:
> On Thu, Jul 31, 2014 at 09:47:12AM +0000, Igor Mammedov wrote:
>> Due to erratum #778 from
>> "Revision Guide for AMD Family 15h Models 10h-1Fh Processors,
>>  Publication # 48931, Issue Date: May 2013, Revision: 3.10"
>>
>> TSC on affected processor, a core may drift under certain conditions,
>> which makes initially synchronized TSCs to become unsynchronized.
> 
> Is this something you're seeing on a real system? If so, how do you
> trigger this?

http://thread.gmane.org/gmane.linux.kernel/1748516 says that Ingo's
time-warp-test fails miserably on this machine.

(The test is at
http://people.redhat.com/mingo/time-warp-test/time-warp-test.c)

Paolo
