Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab3GXEsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:48:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38753 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab3GXEsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:48:16 -0400
Message-ID: <51EF5C77.1050006@zytor.com>
Date: Tue, 23 Jul 2013 21:47:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: introduce hypervisor_cpuid_base()
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <51EE553C.40305@zytor.com> <51EE65F4.3000703@redhat.com> <51EEA96D.3070208@zytor.com> <51EF5BAE.1020905@redhat.com>
In-Reply-To: <51EF5BAE.1020905@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 09:44 PM, Jason Wang wrote:
> 
> Since it's just a minor optimization. How about just keep using the
> strcmp()?
> 

It's more that it enables the rest of the cleanup, making the code
easier to read.

	-hpa

