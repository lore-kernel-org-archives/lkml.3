Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab3IKSfC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:35:02 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:22299 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3IKSfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:35:00 -0400
Message-ID: <5230B7C7.20503@hp.com>
Date: Wed, 11 Sep 2013 14:34:47 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH 1/2] seqlock: Add a new blocking reader type
References: <1378909707-3347-1-git-send-email-Waiman.Long@hp.com> <20130911145536.GJ13318@ZenIV.linux.org.uk> <52309B5F.70406@hp.com> <20130911172624.GK13318@ZenIV.linux.org.uk>
In-Reply-To: <20130911172624.GK13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 01:26 PM, Al Viro wrote:
> On Wed, Sep 11, 2013 at 12:33:35PM -0400, Waiman Long wrote:
>
>>> Folks, any suggestions on better names?  The semantics we are getting is
>> I will welcome any better name suggestion and will incorporate that
>> in the patch.
> FWIW, the suggestions I've seen so far had been
>
> seq_exreadlock() [ex for exclusive]
> seq_exclreadlock() [ditto, and IMO fails the "easily read over the phone"
> test - /sekv-excre...ARRGH/]
> seq_prot_readlock() [prot for protected, as in DLM protected read]

Following the naming convention in seqlock.h that all functions begin 
with read_ or write_, is read_seqexcl_lock() look OK to you?

-Longman
