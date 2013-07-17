Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3GQMUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:20:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18097 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab3GQMUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:20:30 -0400
Date: Wed, 17 Jul 2013 15:20:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] Squashfs: sanity check information from disk
Message-ID: <20130717122015.GA5636@mwanda>
References: <20130715161058.GA23687@elgon.mountain>
 <CAB3wodeBWvgF9oKb9OVXNABiafhvLticB=x8s=R81RRv9Yd6kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB3wodeBWvgF9oKb9OVXNABiafhvLticB=x8s=R81RRv9Yd6kA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 05:20:31AM +0100, Phillip Lougher wrote:
> On 15 July 2013 17:17, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > We read the size of the name from the disk, but a larger name than
> > expected would cause memory corruption.
> 
> Thanks for the patch, it's queued for the next merge window. There's
> one mistake with the patch, but I can fix it when it's applied, or you
> can send a revised patch (see later).

I wouldn't call it a "mistake", it's just a difference in prefered
styles.  The two statements:

	if (size >= SQUASHFS_NAME_LEN + 1) {
and
	if (size > SQUASHFS_NAME_LEN) {

These statements are equivalent.  But I can change it, no worries.

regards,
dan carpenter

