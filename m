Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab3E1LVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 07:21:53 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:52500 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419Ab3E1LVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 07:21:50 -0400
Date: Tue, 28 May 2013 07:21:44 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, hughd@google.com
Subject: Re: [PATCH v4 00/20] change invalidatepage prototype to accept length
Message-ID: <20130528112144.GA11839@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, hughd@google.com
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1305211622330.2469@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1305211622330.2469@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 04:34:25PM +0200, Lukáš Czerner wrote:
> On Tue, 14 May 2013, Lukas Czerner wrote:
> 
> > Date: Tue, 14 May 2013 18:37:14 +0200
> > From: Lukas Czerner <lczerner@redhat.com>
> > To: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
> >     linux-ext4@vger.kernel.org, akpm@linux-foundation.org, hughd@google.com,
> >     lczerner@redhat.com
> > Subject: [PATCH v4 00/20] change invalidatepage prototype to accept length
> 
> Hi Ted,
> 
> you've mentioned that you'll carry the changed in the ext4 tree. Are
> you going to take it for the next merge window ?
> 
> However I still need some review on the mm part of the series,
> Andrew, Hugh, anyone ?

The ext4 tree now has the the v4 version of hte invalidatepage range
patches in it.  So it will be showing up in the next linux-next tree,
for the convenience of the mm folks.  :-)

					- Ted
