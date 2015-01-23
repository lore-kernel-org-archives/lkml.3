Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbbAWKFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:05:41 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:49439 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbbAWKFk convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 23 Jan 2015 05:05:40 -0500
Message-Id: <54C22B040200007800058A07@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 23 Jan 2015 10:05:40 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Borislav Petkov" <bp@alien8.de>
Cc: <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: x86/MCE: drop bogus const modifier from AMD's
 bank4_names()
References: <54C21511020000780005890E@mail.emea.novell.com>
 <20150123095838.GA22635@pd.tnic>
In-Reply-To: <20150123095838.GA22635@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.01.15 at 10:58, <bp@alien8.de> wrote:
> On Fri, Jan 23, 2015 at 08:32:01AM +0000, Jan Beulich wrote:
>> The compiler validly warns about it being ignored.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> Applied, thanks.
> 
> Out of curiosity: When do you see this? Building with
> -Wignored-qualifiers or -Wextra?

It's been a long while ago that I noticed and fixed the warning, so
I don't recall the details. What I do know is that I didn't force any
extra flags, and that a similar issue elsewhere in the tree (fixed
in 3.19-rc5) triggered the same warning in at least one of my builds
(again without any extra warning options) in -rc4.

Jan

