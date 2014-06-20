Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780AbaFTSyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:54:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48044 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520AbaFTSyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:54:41 -0400
Message-ID: <53A48356.5080109@zytor.com>
Date: Fri, 20 Jun 2014 11:54:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
References: <20140620161736.D6AC16FD@viggo.jf.intel.com> <20140620161740.BFB00798@viggo.jf.intel.com> <53A46008.5060509@zytor.com> <53A4619C.8020100@sr71.net> <53A46365.6090101@zytor.com> <20140620174345.GD11391@pd.tnic> <53A473AA.7050301@zytor.com> <20140620180523.GF11391@pd.tnic>
In-Reply-To: <20140620180523.GF11391@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 11:05 AM, Borislav Petkov wrote:
> On Fri, Jun 20, 2014 at 10:47:22AM -0700, H. Peter Anvin wrote:
>> This is run before static_cpu_has().
> 
> static_cpu_has_safe() then - I didn't do it for no reason :-)

No, it has to be cpu_has() -- the dynamic, CPU-specific version.

	-hpa

