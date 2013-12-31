Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3LaMeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 07:34:44 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:33862 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab3LaMel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 07:34:41 -0500
Date: Tue, 31 Dec 2013 07:34:37 -0500
From: Tejun Heo <tj@kernel.org>
To: Masanari Iida <standby24x7@gmail.com>
Cc: Levente Kurusa <levex@linux.com>,
        "trivial@kernel.org" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] [trivial] doc: cgroups: Fix typo in doc/cgroups
Message-ID: <20131231123437.GF3985@htj.dyndns.org>
References: <1387641453-13803-1-git-send-email-standby24x7@gmail.com>
 <52B5C034.50800@linux.com>
 <CALLJCT2r1Qs1aHt2gVAobOx209y_asqcQu83J0rQTVxMax+oMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLJCT2r1Qs1aHt2gVAobOx209y_asqcQu83J0rQTVxMax+oMA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 22, 2013 at 01:26:44AM +0900, Masanari Iida wrote:
> On Sun, Dec 22, 2013 at 1:22 AM, Levente Kurusa <levex@linux.com> wrote:
> > Hi,
> >
> > spotted one more typo.
> >
> > On 12/21/2013 04:57 PM, Masanari Iida wrote:
> >> diff --git a/Documentation/cgroups/resource_counter.txt b/Documentation/cgroups/resource_counter.txt
> >> index c4d99ed..52e1da1 100644
> >> --- a/Documentation/cgroups/resource_counter.txt
> >> +++ b/Documentation/cgroups/resource_counter.txt
> >> @@ -97,8 +97,8 @@ to work with it.
> >>               (struct res_counter *rc, struct res_counter *top,
> >>                unsinged long val)
> >                  ^^^^^^^^^^ should be unsigned.
> >
> > --
> > Regards,
> > Levente Kurusa
> 
> That typo was reported some times ago.
> https://lkml.org/lkml/2013/12/5/468
> So I didn't fix it by myself.

Care to submit a patch?

Thanks.

-- 
tejun
