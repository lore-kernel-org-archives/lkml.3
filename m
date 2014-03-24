Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaCXW60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 18:58:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:58175 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbaCXW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 18:58:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,723,1389772800"; 
   d="scan'208";a="498647911"
Message-ID: <1395701897.2546.9.camel@ideak-mobl>
Subject: Re: [git pull] vfs fixes
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 25 Mar 2014 00:58:17 +0200
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [...]
> Shortlog:
> Al Viro (6):
>       make prepend_name() work correctly when called with negative
*buflen

A proper attribution for the above fix would have been nice. Tracking
down the bug was the main thing after all:

https://lkml.org/lkml/2014/3/12/620

--Imre

