Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab3FRCgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:36:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40587 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751430Ab3FRCgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:36:50 -0400
Message-ID: <1371523003.2088.4.camel@joe-AO722>
Subject: Re: [PATCH 4/4 v2] silicom: checkpatch: errors caused by macros
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Lorenz Haspel <lorenz@badgers.com>, devel@linuxdriverproject.org,
        puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        michael.banken@mathe.stud.uni-erlangen.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Date: Mon, 17 Jun 2013 19:36:43 -0700
In-Reply-To: <20130617211418.GA3219@kroah.com>
References: <1371486386-8043-4-git-send-email-lorenz@badgers.com>
	 <1371496814-26104-1-git-send-email-lorenz@badgers.com>
	 <1371498132.2213.7.camel@joe-AO722> <20130617204922.GM5008@mwanda>
	 <1371503023.2213.9.camel@joe-AO722> <20130617211418.GA3219@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 14:14 -0700, Greg KH wrote:
> On Mon, Jun 17, 2013 at 02:03:43PM -0700, Joe Perches wrote:
> > Generally I think it's better that new submitters patches
> > should go through more strict reviews and be as correct
> > as possible.  I think this is especially true for patches
> > that are just checkpatch driven.
> 
> I totally disagree, sorry.

I'm unsurprised.  We have different tastes.

While whitespace only cleanup patches have some use,
for these types of patches, I'm more interested in
educating others what sorts of patches have higher
value.

o defects
o style/readability
o whitespace

As always, ymmv.

