Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab3HMSKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:10:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35267 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403Ab3HMSKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:10:08 -0400
Message-ID: <520A7651.8020301@zytor.com>
Date: Tue, 13 Aug 2013 11:09:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 04:04 PM, Andi Kleen wrote:
> The x86 user access functions (*_user) were originally very well tuned,
> with partial inline code and other optimizations.
> 
> Then over time various new checks -- particularly the sleep checks for
> a voluntary preempt kernel -- destroyed a lot of the tunings
> 

Hi Andi,

Are you going to respin this patchset to address the feedback?

	-hpa


