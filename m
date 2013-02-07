Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161005Ab3BGR7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:59:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49540 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759261Ab3BGR7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:59:32 -0500
Message-ID: <5113EB64.2080002@zytor.com>
Date: Thu, 07 Feb 2013 09:59:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH] x86: Add support for 64bit get_user() on x86-32
References: <1355312043-11467-1-git-send-email-ville.syrjala@linux.intel.com> <20130207165347.GF9135@intel.com>
In-Reply-To: <20130207165347.GF9135@intel.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 08:53 AM, Ville Syrjälä wrote:
> 
> Based on the initial response there seems to be some interest towards
> it at least. So I'm wondering what's the next step. Is it OK as is,
> or does it need more work, or would people want to extend it to include
> more of the original work?
> 
> I have quite a lot of other stuff on my plate currently, so it'd
> actually be nice if I could find someone to adopt this patch,
> especially if there's interest in increasing the scope.
> 

Well, we can put it in and see what happens.  It looks good from what I
can see.

How have you tested it?

	-hpa

