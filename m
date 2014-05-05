Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaEEJCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:02:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbaEEJCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:02:32 -0400
Date: Mon, 5 May 2014 11:02:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] drivers/hid/hid-picolcd_fb: avoid world-writable
 sysfs files.
In-Reply-To: <874n15c7hg.fsf@rustcorp.com.au>
Message-ID: <alpine.LNX.2.00.1405051102080.3969@pobox.suse.cz>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au> <1398137612-9714-8-git-send-email-rusty@rustcorp.com.au> <20140502214354.67061986@neptune.home> <874n15c7hg.fsf@rustcorp.com.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2014, Rusty Russell wrote:

> >> Cc: Bruno Prémont <bonbons@linux-vserver.org>
> >> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> >
> > Fine with me,
> >   Acked-by: Bruno Prémont <bonbons@linux-vserver.org>
> >
> > Not sure which tree you plan to push this through, CCing Jiri
> > as all picoLCD driver went in via HID tree.
> 
> Currently plan is that they'll go through my modules-next tree (which
> is where this patch originated).

Good. Feel free to add

	Acked-by: Jiri Kosina <jkosina@suse.cz>

then.

Thanks,

-- 
Jiri Kosina
SUSE Labs
