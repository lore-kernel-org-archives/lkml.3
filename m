Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab3C1NXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:23:50 -0400
Received: from claranet-outbound-smtp06.uk.clara.net ([195.8.89.39]:49291 "EHLO
	claranet-outbound-smtp06.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755629Ab3C1NXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:23:48 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Ram Pai <linuxram@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Change in behaviour when unmounting recursive bind mounts
Date: Thu, 28 Mar 2013 13:23:39 +0000
Message-ID: <1591935.QGsMP2PjzI@deuteros>
User-Agent: KMail/4.10.1 (Linux/3.8.4; KDE/4.10.1; x86_64; ; )
In-Reply-To: <1694652.5MYOe5IR6S@deuteros>
References: <2987308.JNKpYDEnfV@deuteros> <20130328030351.GA2033@ram.oc3035372033.ibm.com> <1694652.5MYOe5IR6S@deuteros>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 March 2013 13:05:56 Tvrtko Ursulin wrote:
> Hi,
> 
> On Thursday 28 March 2013 11:03:51 Ram Pai wrote:
> > I tried these commands on a 3.8.0-rc1+ kernel and did not find the
> > problem. Is this on a recent kernel?
> 
> I am on Fedora 17 latest, but I've seen this problem with different kernels.
> Pretty sure from 3.5 something to 3.8 something. All Fedora flavoured. I
> will try vanilla soon.

Just tried with vanilla 3.8.4 and it show exactly the same problem.

There must be something in userspace then which is able to configure the 
"system" (which bit?) into some weird mode where this bug(?) starts to 
trigger.

Regards,

Tvrtko

