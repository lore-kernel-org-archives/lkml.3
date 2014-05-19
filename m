Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaESKtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:49:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaESKtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:49:14 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Karim Raslan <karim.allah.ahmed@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8723au: rtw_sta_mgt: change rtw_alloc_stainfo23a to use gfp_t instead if int
References: <1400395256-8892-1-git-send-email-karim.allah.ahmed@gmail.com>
	<20140519101855.GU15585@mwanda>
	<wrfjtx8mrrp2.fsf@ultrasam.lan.trained-monkey.org>
	<20140519104012.GP16255@mwanda>
Date: Mon, 19 May 2014 12:49:03 +0200
In-Reply-To: <20140519104012.GP16255@mwanda> (Dan Carpenter's message of "Mon,
	19 May 2014 13:40:12 +0300")
Message-ID: <wrfjlhtyrqlc.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:
> On Mon, May 19, 2014 at 12:25:13PM +0200, Jes Sorensen wrote:
>> Dan,
>> 
>> Calm down, I haven't been bombarding the list, due to the sheer volume
>> of commits.  If you want me to spam the list, tell me where and I'll add
>> that to the CC list next time.
>
> We provide the scripts/get_maintainer.pl script for that.  You can leave
> linux-kernel off if you want because they don't care about staging
> drivers.  The staging list is devel@driverdev.osuosl.org.

You should be running your tools against the staging tree automatically,
that way you catch it before it hits the mainline tree.

Just flooding mailing lists for the sake of flooding them doesn't add
any value either.

Jes
