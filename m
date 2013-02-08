Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946831Ab3BHRav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:30:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34521 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab3BHRau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:30:50 -0500
Message-ID: <5115361D.8060501@zytor.com>
Date: Fri, 08 Feb 2013 09:30:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] x86: Add support for 64bit get_user() on x86-32
References: <1355312043-11467-1-git-send-email-ville.syrjala@linux.intel.com> <20130207165347.GF9135@intel.com> <5113EB64.2080002@zytor.com> <20130208162427.GG9135@intel.com>
In-Reply-To: <20130208162427.GG9135@intel.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 08:24 AM, Ville Syrjälä wrote:
>>
>> How have you tested it?
> 
> I've tried it with my drm/kms atomic pageflip/modeset code. I also had
> a small test module that did a couple of different sized get_user()
> calls, but I'll be damned if I can find it again.
> 

Did you see the warning spewage for pointers when you built it?

	-hpa

