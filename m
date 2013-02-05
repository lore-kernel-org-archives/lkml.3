Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3BEHPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:15:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab3BEHPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:15:00 -0500
Date: Tue, 5 Feb 2013 08:14:51 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@localhost
To: Andrew Morton <akpm@linux-foundation.org>
cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 10/18] mm: teach truncate_inode_pages_range() to handle
 non page aligned ranges
In-Reply-To: <20130204125136.b0926f20.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1302050814250.3225@localhost>
References: <1359715424-32318-1-git-send-email-lczerner@redhat.com> <1359715424-32318-11-git-send-email-lczerner@redhat.com> <20130201151502.59398b29.akpm@linux-foundation.org> <alpine.LFD.2.00.1302041510090.3225@localhost>
 <20130204125136.b0926f20.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-1464879651-1360048494=:3225"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-1464879651-1360048494=:3225
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 4 Feb 2013, Andrew Morton wrote:

> Date: Mon, 4 Feb 2013 12:51:36 -0800
> From: Andrew Morton <akpm@linux-foundation.org>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
>     xfs@oss.sgi.com, Hugh Dickins <hughd@google.com>
> Subject: Re: [PATCH 10/18] mm: teach truncate_inode_pages_range() to handle
>     non page aligned ranges
> 
> On Mon, 4 Feb 2013 15:51:19 +0100 (CET)
> Luk____ Czerner <lczerner@redhat.com> wrote:
> 
> > I hope I explained myself well enough :). Are you ok with this king
> > of approach ? If so, I'll resend the patch set without the
> > initialisation-at-declaration.
> 
> uh, maybe.  Next time I'll apply the patch and look at the end result! 
> Try to make it as understandable and (hence) maintainable as possible,
> OK?

Agreed.

Thanks!
-Lukas
--571107329-1464879651-1360048494=:3225--
