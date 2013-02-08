Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760331Ab3BHTJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:09:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35281 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760305Ab3BHTJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:09:32 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130208182308.GI9135@intel.com>
References: <1355312043-11467-1-git-send-email-ville.syrjala@linux.intel.com> <20130207165347.GF9135@intel.com> <5113EB64.2080002@zytor.com> <20130208162427.GG9135@intel.com> <5115361D.8060501@zytor.com> <20130208182308.GI9135@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: Add support for 64bit get_user() on x86-32
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 08 Feb 2013 11:08:52 -0800
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Message-ID: <ea6b316f-c142-4fc0-9f74-281380ab1dac@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, or anything else getting a pointer in memory from user space.

"Ville Syrjälä" <ville.syrjala@linux.intel.com> wrote:

>On Fri, Feb 08, 2013 at 09:30:05AM -0800, H. Peter Anvin wrote:
>> On 02/08/2013 08:24 AM, Ville Syrjälä wrote:
>> >>
>> >> How have you tested it?
>> > 
>> > I've tried it with my drm/kms atomic pageflip/modeset code. I also
>had
>> > a small test module that did a couple of different sized get_user()
>> > calls, but I'll be damned if I can find it again.
>> > 
>> 
>> Did you see the warning spewage for pointers when you built it?
>
>Apparently my config was too small to genenerate enough of those to
>catch
>my eye. Most of those seem to come from drivers that have pointers in
>their
>ioctl structs, no?

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
