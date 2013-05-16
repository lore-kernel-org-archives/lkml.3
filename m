Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3EPWQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:16:00 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46955 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3EPWP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:15:58 -0400
Date: Thu, 16 May 2013 19:15:31 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Maen Suleiman <maen@marvell.com>, linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] drivers: memory: Introduce Marvell EBU Device Bus driver
Message-ID: <20130516221530.GA15738@localhost>
References: <1366744886-3019-1-git-send-email-elezegarcia@gmail.com>
 <20130423194822.GA7214@kroah.com>
 <20130423195556.GA3335@localhost>
 <20130513201234.GB31290@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130513201234.GB31290@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, May 13, 2013 at 04:12:34PM -0400, Jason Cooper wrote:
> On Tue, Apr 23, 2013 at 04:55:58PM -0300, Ezequiel Garcia wrote:
> > On Tue, Apr 23, 2013 at 12:48:22PM -0700, Greg KH wrote:
> > > On Tue, Apr 23, 2013 at 04:21:26PM -0300, Ezequiel Garcia wrote:
[...]
> > > It's way too late for new drivers for 3.10, sorry.  I'll hold on to this
> > > and merge it to my trees after 3.10-rc1 is out for inclusion in 3.11.
> > > 
> > 
> > That's fine, no problem.
> 
> I'm dropping this from my tree as Greg has said he would take it.
> 

Do you plan to take this through your trees? Which tree should I be
monitoring? If at all possible, I'd love to see this in linux-next
somewhat soon, to avoid future problems.

Thanks!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
