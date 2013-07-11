Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab3GKNzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:55:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab3GKNzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:55:41 -0400
Date: Thu, 11 Jul 2013 14:55:22 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alasdair G Kergon <agk@redhat.com>, Yann Droneaud <ydroneaud@opteya.com>,
        Mike Snitzer <snitzer@redhat.com>, Robin Dong <sanbai@taobao.com>,
        linux-kernel@vger.kernel.org, Jim Ramsay <jim_ramsay@dell.com>,
        dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Rob Herring <robherring2@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Milan Broz <gmazyland@gmail.com>, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [dm-devel] [git pull] device-mapper changes for 3.11
Message-ID: <20130711135522.GN8530@agk-dp.fab.redhat.com>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Alasdair G Kergon <agk@redhat.com>,
	Yann Droneaud <ydroneaud@opteya.com>,
	Mike Snitzer <snitzer@redhat.com>, Robin Dong <sanbai@taobao.com>,
	linux-kernel@vger.kernel.org, Jim Ramsay <jim_ramsay@dell.com>,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Rob Herring <robherring2@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Milan Broz <gmazyland@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
References: <20130711013448.GD32399@agk-dp.fab.redhat.com> <20130711162040.8a82cb97a6c647c4f61f919b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711162040.8a82cb97a6c647c4f61f919b@canb.auug.org.au>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 04:20:40PM +1000, Stephen Rothwell wrote:
> Alistair, is there some reason that you cannot maintain some relatively
> stable git tree for me to fetch (instead of the quilt series).  

Well Mike Snitzer is becoming a joint maintainer and this also requires
changes to the workflow so watch this space.

> Also,
> there is not real reason to keep rebasing this stuff (especially just
> before sending it to Linus).
 
Most of the time the patches are decoupled from the rest of the tree
and the final linux-next kernel is the same regardless of where the
quilt tree is attached.  I maintain a single sequence of patches 
where the ones ready for upstream float up to the top and the
linux-next export is a by-product and not the primary output.

Anyway, like I say, we'll be changing things during the next couple of
cycles and we'll bear your suggestions in mind.

Alasdair

