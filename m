Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867Ab3GWSZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:25:39 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:56211 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204Ab3GWSZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:25:34 -0400
Message-ID: <1374603925.20981.8.camel@desktop>
Subject: Re: [PATCH] Staging: bcm: Qos: Fix some coding style issues
From: Lilis Iskandar <veeableful@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Wed, 24 Jul 2013 02:25:25 +0800
In-Reply-To: <1374597753.3387.4.camel@joe-AO722>
References: <1374571229.15906.3.camel@desktop>
	 <20130723095416.GM5585@mwanda> <1374574241.17286.8.camel@desktop>
	 <20130723101838.GN5585@mwanda> <1374580262.19434.4.camel@desktop>
	 <1374597753.3387.4.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 09:42 -0700, Joe Perches wrote:
> On Tue, 2013-07-23 at 19:51 +0800, Lilis Iskandar wrote:
> > Fixed spacing/tabs issues that were found using checkpatch.
> 
> Hi Lilis.
> 
> It'd be better to change the email subject to
> "[PATCH v2] etc..." to show that's it's a new
> version of the patch.
> 
> It's also useful to add a note or two like
> "git diff -w shows no differences" and
> "no differences in objects" to make review
> and acceptance a bit easier.
> 
> Good luck with continued cleanups of bcm.
> There's a lot to clean in those files.

Thanks for the advice! I'll keep that in mind for the following patches.

