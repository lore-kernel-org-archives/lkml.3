Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934716AbaFTQaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:30:23 -0400
Received: from www.sr71.net ([198.145.64.142]:53776 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228AbaFTQaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:30:22 -0400
Message-ID: <53A4619C.8020100@sr71.net>
Date: Fri, 20 Jun 2014 09:30:20 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
CC: bp@alien8.de, x86@kernel.org
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
References: <20140620161736.D6AC16FD@viggo.jf.intel.com> <20140620161740.BFB00798@viggo.jf.intel.com> <53A46008.5060509@zytor.com>
In-Reply-To: <53A46008.5060509@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 09:23 AM, H. Peter Anvin wrote:
> On 06/20/2014 09:17 AM, Dave Hansen wrote:
>> > Today, we assume that all 64-bit cpus have X86_FEATURE_MP.  It
>> > should be in the REQUIRED_MASK so that we do not need the #undef
>> > trick for it.
> I don't think we enforce that the MP bit is set in CPUID, though.
> Non-AMD processors will typically not set this bit at all, so the
> feature validation code would have to be modified to know to not require
> this bit.

Ahh, OK.  I'll drop this.
