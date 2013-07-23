Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3GWOtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:49:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60107 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757669Ab3GWOs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:48:58 -0400
Message-ID: <51EE97BD.4050402@zytor.com>
Date: Tue, 23 Jul 2013 07:48:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>
CC: Jason Wang <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@redhat.com" <gleb@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <1374572465-15278-4-git-send-email-jasowang@redhat.com> <bd93bc49300a4d99996cc4f57c19a008@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <bd93bc49300a4d99996cc4f57c19a008@SN2PR03MB061.namprd03.prod.outlook.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 06:55 AM, KY Srinivasan wrote:
> 
> This strategy of hypervisor detection based on some detection order IMHO is not
> a robust detection strategy. The current scheme works since the only hypervisor emulated
> (by other hypervisors happens to be Hyper-V). What if this were to change.
> 

One strategy would be to pick the *last* one in the CPUID list, since
the ones before it are logically the one(s) being emulated...

	-hpa


