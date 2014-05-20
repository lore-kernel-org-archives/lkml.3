Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaETRyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:54:20 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:37949 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaETRyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:54:19 -0400
Date: Wed, 21 May 2014 01:52:17 +0400
From: Anton Saraev <antonysaraev@gmail.com>
To: Jake Edge <jake@lwn.net>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 0/3] staging/skein: more cleanup
Message-ID: <20140520215217.GB1692@Ruffial>
References: <20140520075612.220a13ae@chukar.edge2.net>
 <20140520144757.GA8664@titan.lakedaemon.net>
 <20140520102411.413d565d@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520102411.413d565d@chukar.edge2.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 10:24:11AM -0600, Jake Edge wrote:
> On Tue, 20 May 2014 10:47:57 -0400 Jason Cooper wrote:
>
> but some kind of tests are needed to ensure nothing breaks before
> digging into that ...

I have some test: slightly modified version of tests from
https://github.com/wernerd/Skein3Fish. It works as debugfs entry
and require some modification needed for module support
("public" function must be extern). As I can understand Jason
has his own tests. That would be logical to share them but
I don't know where.
