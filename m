Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3IDEbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 00:31:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50454 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753639Ab3IDEbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 00:31:31 -0400
Message-ID: <1378269089.7347.59.camel@joe-AO722>
Subject: Re: [E1000-devel] [PATCH 0/4] i40e: Neatening and object size
 reductions
From: Joe Perches <joe@perches.com>
To: "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 03 Sep 2013 21:31:29 -0700
In-Reply-To: <FC41C24E35F18A40888AACA1A36F3E416C61C0E5@FMSMSX102.amr.corp.intel.com>
References: <cover.1377903831.git.joe@perches.com>
	 <FC41C24E35F18A40888AACA1A36F3E416C61C0E5@FMSMSX102.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-04 at 01:00 +000, Nelson, Shannon wrote:
> we hadn't noticed the new experimental "--fix" option before.  There
> are a lot of good suggestions there, but obviously it needs a lot of
> reading and tweaking before it can be used.

Yes, I think --fix works best on patches.

When you use -f and --fix together, it can do inappropriate things.

Using multiple passes of -f --fix --types=<ONE_SPECIFIC_TYPE> and
changing the "ONE_SPECIFIC_TYPE" can produce more reasonable patch
sequences.

If you do try it, and please remember it is experimental, do let me
know how well it works or doesn't work for you all.

Bug reports (and patches) welcome.

cheers, Joe

