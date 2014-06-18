Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaFRQSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:18:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:17422 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbaFRQSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:18:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,501,1400050800"; 
   d="scan'208";a="559645300"
Message-ID: <53A1BBB3.4070809@intel.com>
Date: Wed, 18 Jun 2014 09:17:55 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com> <20140618095739.GA24419@pd.tnic> <53A1A3A5.9010109@intel.com> <20140618144429.GD24024@pd.tnic> <53A1A90D.5010604@intel.com> <20140618152505.GE24024@pd.tnic>
In-Reply-To: <20140618152505.GE24024@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 08:25 AM, Borislav Petkov wrote:
> +config X86_INTEL_MPX
> +       def_bool y
> +       depends on CPU_SUP_INTEL
> 
> which means, even on !MPX Intels, you need to explicitly say "no" here.
> Is this how the configuration is supposed to be done?

I think we need to promote this to a real option with real help text.

