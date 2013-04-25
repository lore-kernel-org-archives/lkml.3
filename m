Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab3DYWPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:15:50 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:52852 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063Ab3DYWPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:15:49 -0400
Message-ID: <5179AB11.90509@gmail.com>
Date: Thu, 25 Apr 2013 15:15:45 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Borislav Petkov <bp@suse.de>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] extable: Flip the sorting message
References: <1366023109-12098-1-git-send-email-bp@alien8.de> <5179A625.1080502@zytor.com> <20130425220518.GC312@pd.tnic> <5179A91A.5080709@zytor.com>
In-Reply-To: <5179A91A.5080709@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 03:07 PM, H. Peter Anvin wrote:
> On 04/25/2013 03:05 PM, Borislav Petkov wrote:
>>
>> One possible reason for having it flipped is to encourage runtime
>> sorting arches to convert to build time sorting.
>>
>
> This is actually somewhat valid, plus it is the point in time when
> something actually is *happening*.  A message saying "nothing happened"
> isn't actually all that interesting...
>

Good points.  As the original author of the whole mess, I don't have a 
strong preference.  Certainly printing the message, that nothing is 
happening, goes against one of the main reasons for doing the sort in 
the first place:  Speeding up booting.

David Daney

