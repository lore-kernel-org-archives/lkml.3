Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966639Ab3HHVCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:02:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48814 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966627Ab3HHVCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:02:48 -0400
Message-ID: <1375995766.2087.7.camel@joe-AO722>
Subject: Re: Review [2/2] Staging: BCM: Removed more whitespace/Errors
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Paul McQuade <paulmcquad@gmail.com>,
        Linux-Devel <devel@driverdev.osuosl.org>, gregkh@linuxfoundation.org,
        Linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 08 Aug 2013 14:02:46 -0700
In-Reply-To: <20130808205432.GD5502@mwanda>
References: <5203D6E4.9080201@gmail.com>
	 <1375987848.2424.163.camel@joe-AO722> <20130808205432.GD5502@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 23:54 +0300, Dan Carpenter wrote:
> Joe, these automated checkpatch.pl things are annoying.  It's too
> easy to flood maintainers with hundreds of patches.  We need to
> figure out how to make these things easier to review.

I have yet to see anyone submit a patch using
$ scripts/checkpatch.pl --fix -f <file>



