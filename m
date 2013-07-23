Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580Ab3GWQmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:42:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56034 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932705Ab3GWQmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:42:35 -0400
Message-ID: <1374597753.3387.4.camel@joe-AO722>
Subject: Re: [PATCH] Staging: bcm: Qos: Fix some coding style issues
From: Joe Perches <joe@perches.com>
To: Lilis Iskandar <veeableful@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 09:42:33 -0700
In-Reply-To: <1374580262.19434.4.camel@desktop>
References: <1374571229.15906.3.camel@desktop>
	 <20130723095416.GM5585@mwanda> <1374574241.17286.8.camel@desktop>
	 <20130723101838.GN5585@mwanda> <1374580262.19434.4.camel@desktop>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 19:51 +0800, Lilis Iskandar wrote:
> Fixed spacing/tabs issues that were found using checkpatch.

Hi Lilis.

It'd be better to change the email subject to
"[PATCH v2] etc..." to show that's it's a new
version of the patch.

It's also useful to add a note or two like
"git diff -w shows no differences" and
"no differences in objects" to make review
and acceptance a bit easier.

Good luck with continued cleanups of bcm.
There's a lot to clean in those files.

