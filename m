Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab3D3Ibk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:31:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62558 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759465Ab3D3Ibh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:31:37 -0400
Message-ID: <1367310625.4616.71.camel@marge.simpson.net>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
From: Mike Galbraith <bitbucket@online.de>
To: Len Brown <lenb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Alex Shi <alex.shi@intel.com>,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com, Linux PM list <linux-pm@vger.kernel.org>
Date: Tue, 30 Apr 2013 10:30:25 +0200
In-Reply-To: <1367298972.4616.41.camel@marge.simpson.net>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
	 <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com>
	 <20130412162348.GE2368@pd.tnic>
	 <1365785311.5814.36.camel@marge.simpson.net> <516F19EE.5060309@kernel.org>
	 <1366989087.30242.11.camel@marge.simpson.net>
	 <1367298972.4616.41.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:4Q9NhZvxryq5V5Na4WfhRC7RnPVb0OfWzk43Hxsc7y5
 RORwxouHLkrGzHBPMWQMEtkRn7cel1xc7Qi+X+h1WEy00oYFTR
 y+7Tjld7oCvQAk0JR4FnJVeIquze5kIahdN+yvvzDZjn2/MW+j
 oIEC/kF+N1YFtWolMz+kb15oBOnioy6oXzBeLFH3MMZqXONyuH
 T6Lqq6C3zdWn83fifmE2+OuAT6kkr5gUv4Gopti07hq4rlXioc
 62LujuKhv2JoCldJN4UwIrW22zZS+AjIWGFv3ngmxicpo0Xwux
 XfoYqn+/SMZ0kW5BmG/emHb/DYGVBDrTeeZrCLjV28E5j7pD7H
 3kGJHcMD4ISn8vDgFk86isEOE9iYCKzxbsx68r4w+NW/+hW7OP
 9bFx7C3t0reYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 07:16 +0200, Mike Galbraith wrote:

> Well now, that's not exactly what I expected to see for AIM7 compute.
> Filesystem is munching cycles otherwise used for compute when load is
> spread across the whole box vs consolidated.

So AIM7 compute performance delta boils down to: powersaving stacks
tasks, so they pat single bit of spinning rust sequentially/gently.

-Mike

