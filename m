Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab3DYWR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:17:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60828 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432Ab3DYWR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:17:56 -0400
Message-ID: <5179AB6D.8040504@zytor.com>
Date: Thu, 25 Apr 2013 15:17:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Borislav Petkov <bp@suse.de>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] extable: Flip the sorting message
References: <1366023109-12098-1-git-send-email-bp@alien8.de> <5179A625.1080502@zytor.com> <20130425220518.GC312@pd.tnic> <5179A91A.5080709@zytor.com> <5179AB11.90509@gmail.com>
In-Reply-To: <5179AB11.90509@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 03:15 PM, David Daney wrote:
> 
> Good points.  As the original author of the whole mess, I don't have a
> strong preference.  Certainly printing the message, that nothing is
> happening, goes against one of the main reasons for doing the sort in
> the first place:  Speeding up booting.
> 

Yes, not to mention making early trap overrides doable.

	-hpa


