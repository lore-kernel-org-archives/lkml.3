Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab3DYWIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:08:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60761 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903Ab3DYWIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:08:04 -0400
Message-ID: <5179A91A.5080709@zytor.com>
Date: Thu, 25 Apr 2013 15:07:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] extable: Flip the sorting message
References: <1366023109-12098-1-git-send-email-bp@alien8.de> <5179A625.1080502@zytor.com> <20130425220518.GC312@pd.tnic>
In-Reply-To: <20130425220518.GC312@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 03:05 PM, Borislav Petkov wrote:
> 
> One possible reason for having it flipped is to encourage runtime
> sorting arches to convert to build time sorting.
> 

This is actually somewhat valid, plus it is the point in time when
something actually is *happening*.  A message saying "nothing happened"
isn't actually all that interesting...

	-hpa

