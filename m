Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3J1V1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:27:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab3J1V1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:27:37 -0400
Date: Mon, 28 Oct 2013 22:29:45 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] percpu_ida: Various tweaks
Message-ID: <20131028212945.GA15849@dhcp-26-207.brq.redhat.com>
References: <20131028100440.GA5744@dhcp-26-207.brq.redhat.com>
 <20131028212352.GH8153@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028212352.GH8153@kmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 02:23:52PM -0700, Kent Overstreet wrote:
> What tree is this series based on? Patch 3 is based on something not in
> mainline.

This is against the Jens's tree:
git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git

Sorry for missing to note right away.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
