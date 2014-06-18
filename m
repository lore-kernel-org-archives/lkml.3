Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaFRPB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:01:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46896 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaFRPBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:01:07 -0400
Message-ID: <53A1A98D.8050408@zytor.com>
Date: Wed, 18 Jun 2014 08:00:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>
CC: Qiaowei Ren <qiaowei.ren@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com> <20140618095739.GA24419@pd.tnic> <53A1A3A5.9010109@intel.com> <20140618144429.GD24024@pd.tnic>
In-Reply-To: <20140618144429.GD24024@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 07:44 AM, Borislav Petkov wrote:
> 
> Why?
> 
> Practically, distros will have it enabled anyway (you have X86_INTEL_MPX
> depend on CPU_SUP_INTEL).
> 
> Are you talking about the miniscule percentage of people building their
> own kernels?
> 

We have people working hard to shave kilobytes off the smallest
configurations, because they want to fit into a megabyte of memory with
the kernel and application.

Let's try to not make their life harder than it needs to be.

	-hpa

