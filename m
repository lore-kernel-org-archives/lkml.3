Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab3IOQeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 12:34:09 -0400
Received: from mx-out.ocsa-data.net ([194.36.166.37]:56489 "EHLO
	mx-out.ocsa-data.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab3IOQeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 12:34:08 -0400
Message-ID: <1379262842.9257.1.camel@dworkin>
Subject: Re: [PATCH v3 8/8] industrialio: use anon_inode_getfd() with
 O_CLOEXEC flag
From: Yann Droneaud <ydroneaud@opteya.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Date: Sun, 15 Sep 2013 18:34:02 +0200
In-Reply-To: <5235DFD2.4050008@kernel.org>
References: <cover.1378460926.git.ydroneaud@opteya.com>
	 <91c7332bc0616447587ec64a0c8f512a1d9e498d.1378460926.git.ydroneaud@opteya.com>
	 <5235DFD2.4050008@kernel.org>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Spam-Score: -1.44
X-abuse-contact: abuse@ocsa-data.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le dimanche 15 septembre 2013 à 17:26 +0100, Jonathan Cameron a écrit :
> On 09/06/13 11:39, Yann Droneaud wrote:

[...]

> >   http://lkml.kernel.org/r/cover.1377372576.git.ydroneaud@opteya.com
> > 
> > Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> > Link: http://lkml.kernel.org/r/cover.1378460926.git.ydroneaud@opteya.com
> 
> Thanks Yann.  I had no idea about this issue but your well supported description
> above made this easy to review.
> 
> Applied to the togreg branch of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git
> as it's not a regression but if there is support for pushing this back to stable
> I personally am not against it.
> 

It's not a -stable materiel. So let it flow to v3.12 or v3.13.

Thanks for the review.

Regards.

-- 
Yann Droneaud
OPTEYA


