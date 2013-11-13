Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab3KMEvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 23:51:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43979 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069Ab3KMEvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 23:51:33 -0500
Message-ID: <52830546.8010002@zytor.com>
Date: Tue, 12 Nov 2013 20:51:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg Price <price@MIT.EDU>
CC: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 00/11] random: code cleanups
References: <cover.1383868558.git.price@mit.edu> <20131112042444.GC30281@thunk.org> <20131112224009.GX8043@ringworld.MIT.EDU> <20131113033205.GA9214@thunk.org> <5282F9C1.3020007@zytor.com> <20131113043702.GZ8043@ringworld.MIT.EDU>
In-Reply-To: <20131113043702.GZ8043@ringworld.MIT.EDU>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 08:37 PM, Greg Price wrote:
> 
> I'm thinking only of boot-time blocking.  The idea is that once
> /dev/urandom is seeded with, say, 128 bits of min-entropy in the
> absolute, information-theoretic sense, it can produce an infinite
> supply (or something like 2^128 bits, which amounts to the same thing)
> of bits that can't be distinguished from random, short of breaking or
> brute-forcing the crypto.  So once it's seeded, it's good forever.
> 

And, pray tell, how will you know that you have done that?

Even the best entropy estimation algorithms are nothing but estimations,
and min-entropy is the hardest form of entropy to estimate.

	-hpa

