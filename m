Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800Ab3JOXpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 19:45:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51559 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759587Ab3JOXpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 19:45:02 -0400
Message-ID: <525DD362.4070807@zytor.com>
Date: Tue, 15 Oct 2013 16:44:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>
CC: mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v4 12/12] intel_mid: Moved board related code to a new
 file
References: <1381880568-20730-1-git-send-email-david.a.cohen@linux.intel.com> <1381880568-20730-13-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1381880568-20730-13-git-send-email-david.a.cohen@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 04:42 PM, David Cohen wrote:
>  
> +#define intel_mid_sfi_dev(i)   \
> +		static const struct devs_id *__intel_mid_sfi_##i##_dev __used \
> +		__attribute__((__section__(".x86_intel_mid_dev.init"))) = &i
> +

Any reason to not just call this "sfi_device()" or something similar?
"Intel MID SFI" seems a bit redundant...

	-hpa


