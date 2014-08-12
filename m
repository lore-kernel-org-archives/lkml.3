Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaHLK21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 06:28:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47625 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070AbaHLK20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 06:28:26 -0400
Date: Tue, 12 Aug 2014 11:28:07 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] asm-generic: add memfd_create system call to unistd.h
Message-ID: <20140812102807.GH29013@arm.com>
References: <1407764228-7904-1-git-send-email-will.deacon@arm.com>
 <CANq1E4Q0gDaJ5XGnkoCQsG8xLh1Q-EBErtEVPpeeZgGj+Nr8dQ@mail.gmail.com>
 <20140811171511.GF8828@arm.com>
 <201408112057.01177.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201408112057.01177.arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 07:57:00PM +0100, Arnd Bergmann wrote:
> On Monday 11 August 2014, Will Deacon wrote:
> > On Mon, Aug 11, 2014 at 05:54:08PM +0100, David Herrmann wrote:
> > > On Mon, Aug 11, 2014 at 3:37 PM, Will Deacon <will.deacon@arm.com> wrote:
> > > > Commit 9183df25fe7b ("shm: add memfd_create() syscall") added a new
> > > > system call (memfd_create) but didn't update the asm-generic unistd
> > > > header.
> > > >
> > > > This patch adds the new system call to the asm-generic version of
> > > > unistd.h so that it can be used by architectures such as arm64.
> > > >
> > > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > > Cc: David Herrmann <dh.herrmann@gmail.com>
> > > > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > > 
> > > Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> > 
> > Thanks, David.
> > 
> > Arnd: shall I take this via the arm64 tree, or do you already have some
> > asm-generic patches queued?
> 
> Please take it for arm64, I don't have any other patches queued at the moment
> and am currently on vacation.

Thanks, Arnd. I'll include it with the arm64 pull req at -rc1.

Have a good holiday,

Will
