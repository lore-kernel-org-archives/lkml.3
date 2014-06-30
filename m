Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaF3P1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:27:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaF3P1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:27:08 -0400
Message-ID: <53B1819B.40405@redhat.com>
Date: Mon, 30 Jun 2014 17:26:19 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Gleb Natapov <gleb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org,
        =?windows-1252?Q?J=F6rg_?= =?windows-1252?Q?R=F6del?= 
	<joro@8bytes.org>
Subject: Re: [PATCH] KVM: SVM: Fix CPL export via SS.DPL
References: <53AFE2B3.5080300@web.de> <20140629102403.GE18167@minantech.com> <53AFEB16.5040608@web.de> <20140629105339.GF18167@minantech.com> <53AFF192.7020801@web.de> <20140629115143.GA4362@pd.tnic> <53B0050B.90104@web.de> <20140629131443.GA5199@pd.tnic> <20140629134247.GG18167@minantech.com> <20140629140104.GB12528@pd.tnic> <20140629142722.GH18167@minantech.com> <53B02395.8030505@web.de> <53B027E0.7040003@web.de> <53B02CEB.7010607@web.de> <53B17BDD.5030301@redhat.com> <53B17C5D.5050407@web.de>
In-Reply-To: <53B17C5D.5050407@web.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/06/2014 17:03, Jan Kiszka ha scritto:
> 15.5.1:
>
> "When examining segment attributes after a #VMEXIT:
> [...]
> • Retrieve the CPL from the CPL field in the VMCB, not from any segment
> DPL."

It's only the fourth paragraph below the one I did read...

Paolo
