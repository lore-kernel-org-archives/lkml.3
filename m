Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab3KJWDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 17:03:42 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:51711 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab3KJWDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 17:03:34 -0500
Date: Sun, 10 Nov 2013 16:03:29 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation/ABI: Document the non-ABI status of
 Kconfig and symbols
To: Josh Triplett <josh@joshtriplett.org>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tao Ma <boyu.mt@taobao.com>, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20131024090825.GA3217@leaf> (from josh@joshtriplett.org on Thu
	Oct 24 04:08:30 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1384121009.1974.263@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 04:08:30 AM, Josh Triplett wrote:
> On Thu, Oct 24, 2013 at 10:57:11AM +0200, Richard Weinberger wrote:
> > On Thu, Oct 24, 2013 at 10:41 AM, Josh Triplett  
> <josh@joshtriplett.org> wrote:
> > > Discussion at Kernel Summit made it clear that the presence or  
> absence
> > > of specific Kconfig symbols are not considered ABI, and that no
> > > userspace (or bootloader, etc) should rely on them.
> > >
> > > In addition, kernel-internal symbols are well established as  
> non-ABI,
> > > per Documentation/stable_api_nonsense.txt.
> > >
> > > Document both of these in Documentation/ABI/README, in a new  
> section for
> > > notable bits of non-ABI.
> > >
> > > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > > ---
> > >  Documentation/ABI/README | 13 +++++++++++++
> > >  1 file changed, 13 insertions(+)

Should I grab this, or is it already going in through somebody else's  
tree?

Rob