Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaAWPa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:30:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54375 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbaAWPa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:30:57 -0500
Message-ID: <52E1358A.7020206@zytor.com>
Date: Thu, 23 Jan 2014 07:30:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Bin Gao <bin.gao@intel.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86, tsc: Add missing Baytrail frequency to the table
References: <1390475043-27457-1-git-send-email-mika.westerberg@linux.intel.com> <20140123150912.7ee822a0@alan.etchedpixels.co.uk>
In-Reply-To: <20140123150912.7ee822a0@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 07:09 AM, One Thousand Gnomes wrote:
> On Thu, 23 Jan 2014 13:04:03 +0200
> Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> 
>> Baytrail is based on Silvermont core so MSR_FSB_FREQ[2:0] == 0 means that
>> the CPU reference clock runs at 83.3MHz. Without this we crash a bit later
>> with backtrace looking like:
> 
> Would it not be wise to also make the code robust against future failures
> of this kind and at least bitch rather than divide by 0 ?
> 

Chicken!  ;)

	-hpa


