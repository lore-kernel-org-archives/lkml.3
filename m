Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab3GZVs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:48:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38573 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752595Ab3GZVs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:48:27 -0400
Message-ID: <1374875305.2009.16.camel@joe-AO722>
Subject: Re: [PATCH 1/2] Staging: bcm: InterfaceIdleMode: Fixed
 spacing/tabing issues
From: Joe Perches <joe@perches.com>
To: Lilis Iskandar <veeableful@gmail.com>
Cc: gregkh@linuxfoundation.org, tulinizer@gmail.com, klmckinney1@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Jul 2013 14:48:25 -0700
In-Reply-To: <1374843573.1802.3.camel@desktop>
References: <1374843573.1802.3.camel@desktop>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-26 at 20:59 +0800, Lilis Iskandar wrote:
> Fixed spacing/tabing issues.

two b's in tabbing.

First send the emails to yourself and make sure
they apply with git am

Remember mentioning git diff -w.

You also might try to use

$ ./scripts/checkpatch.pl -f --fix --test-only=space drivers/staging/bcm/*.[ch] 
$ ls drivers/staging/bcm/*EXPERIMENTAL-checkpatch-fixes | \
  while read file ; do \
    mv $file ${file%.EXPERIMENTAL-checkpatch-fixes}; \
  done
$ git diff drivers/staging/bcm


