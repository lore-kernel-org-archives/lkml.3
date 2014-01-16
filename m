Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaAPDIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 22:08:42 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:62853 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAPDIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 22:08:40 -0500
MIME-Version: 1.0
In-Reply-To: <309B89C4C689E141A5FF6A0C5FB2118B7312DF41@ORSMSX101.amr.corp.intel.com>
References: <1389795148-341-1-git-send-email-ethan.kernel@gmail.com>
	<309B89C4C689E141A5FF6A0C5FB2118B7312DA20@ORSMSX101.amr.corp.intel.com>
	<CABawtvNEDjTJAjJ9TeEvZd7+2kD=H6zA23T-aQo3uVm5SUEhCQ@mail.gmail.com>
	<309B89C4C689E141A5FF6A0C5FB2118B7312DE7D@ORSMSX101.amr.corp.intel.com>
	<CABawtvNSpDU+pjdJOpCB8kyQqA7B9N4g0S_yPgQaZnB3h0+nFg@mail.gmail.com>
	<309B89C4C689E141A5FF6A0C5FB2118B7312DF41@ORSMSX101.amr.corp.intel.com>
Date: Thu, 16 Jan 2014 11:08:39 +0800
Message-ID: <CABawtvPJ1ObkwbKjVtzajQnn_181CTo-jmLc0uGY2nqZw9_jtg@mail.gmail.com>
Subject: Re: [PATCH 1/2 v3] ixgbe: define IXGBE_MAX_VFS_DRV_LIMIT macro and
 cleanup const 63
From: Ethan Zhao <ethan.kernel@gmail.com>
To: "Brown, Aaron F" <aaron.f.brown@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron,
    Ok, Dave Miler's net-next tree.

Thanks,
Etan

On Thu, Jan 16, 2014 at 10:51 AM, Brown, Aaron F
<aaron.f.brown@intel.com> wrote:
> On Thu, 2014-01-16 at 09:58 +0800, Ethan Zhao wrote:
>> Aaron,
>>
>> Is this your net-next repo ? if so, I rebuild the patch with this repo
>> right now .
>> git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-next.git
>>
>> Thanks,
>> Ethan
>>
> Only sort of.  Jeff uses it to push patches up, but I don't have an
> account there so am simply sending them up the old fashioned way, via
> email, hence it is probably not getting updated while Jeff is out.
>
> As long as your patch can apply cleanly to Dave Miller's net-next tree I
> should be able to pull it into our internal ones.
