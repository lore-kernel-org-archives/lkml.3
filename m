Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934694AbaGPQma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:42:30 -0400
Received: from wolff.to ([98.103.208.27]:46188 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965444AbaGPQm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:42:27 -0400
Date: Wed, 16 Jul 2014 11:40:54 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Donald <gdonald@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: find_busiest_group divide error
Message-ID: <20140716164054.GA10952@wolff.to>
References: <20140714165659.GA9289@gmail.com>
 <20140716152736.GD19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20140716152736.GD19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> So I tried checking out specific revisions and found
>> 09dc4ab03936df5c5aa711d27c81283c6d09f495 is the latest good revision I
>> can boot.  The first bad revision I hit is
>> 51f2176d74ace4c3f58579a605ef5a9720befb00.
>>
>> I have no idea how to fix it.  I'm just a web developer/kernel tester :(
>>
>
>Could you confirm if reverting caffcdd8d27ba78730d5540396ce72ad022aff2c
>cures things for you?

I think caffcdd8d27ba78730d5540396ce72ad022aff2c was merged after 
3.15 (even though it seems to be based off of 3.15-rc6).
