Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3CEWLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:11:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37138 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab3CEWLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:11:37 -0500
Message-ID: <51366CE6.4090905@zytor.com>
Date: Tue, 05 Mar 2013 14:08:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Raphael S.Carvalho" <raphael.scarv@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] arch/x86/smpboot.c: Fix GCC Warning (unused variable)!
References: <1362508625-7803-1-git-send-email-raphael.scarv@gmail.com> <alpine.LFD.2.02.1303052257060.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1303052257060.22263@ionos>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 02:02 PM, Thomas Gleixner wrote:
> 
> What is your patch solving? How about removing the line completely?
> And how about providing a changelog which makes sense ?
> 
> Thanks,
> 
> 	tglx
>  

We already have an actually correct patch for this warning; I will apply
it later.

	-hpa


