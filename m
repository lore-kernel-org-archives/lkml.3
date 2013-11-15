Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3KOWmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:42:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62686 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750992Ab3KOWmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:42:37 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: rafael.j.wysocki@intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [v3.11][3.12][Regression]  ACPI / processor: Use common hotplug infrastructure
Date: Fri, 15 Nov 2013 23:55:10 +0100
Message-ID: <19794987.1PROc0XFg1@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52865D6B.1080902@canonical.com>
References: <52865D6B.1080902@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 15, 2013 12:44:11 PM Joseph Salisbury wrote:
> Hi Rafael,
> 
> A kernel bug affecting several users was opened against Ubuntu[0]. 
> After a bisect, it was found the following commit introduced the regression:
> 
> commit ac212b6980d8d5eda705864fc5a8ecddc6d6eacc
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date: Fri May 3 00:26:22 2013 +0200
> 
>     ACPI / processor: Use common hotplug infrastructure
> 
> The regression was introduced as of v3.11-rc1.
> 
> This commit doesn't revert cleanly in 3.12, and requires the revert of
> other commits as well.  I wanted to get your feedback since you are the
> author.

Well, that commit has nothing to do with PCMCIA, so I'm not sure how the
breakage is related to it.

Moreover, comment #8 reports 3.11.0-11.17 as working and the change you're
asking about should be in that kernel as well.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
