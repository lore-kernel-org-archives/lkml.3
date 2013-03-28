Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab3C1NGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:06:14 -0400
Received: from claranet-outbound-smtp02.uk.clara.net ([195.8.89.35]:34621 "EHLO
	claranet-outbound-smtp02.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755387Ab3C1NGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:06:12 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Ram Pai <linuxram@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Change in behaviour when unmounting recursive bind mounts
Date: Thu, 28 Mar 2013 13:05:56 +0000
Message-ID: <1694652.5MYOe5IR6S@deuteros>
User-Agent: KMail/4.10.1 (Linux/3.8.3-103.fc17.x86_64; KDE/4.10.1; x86_64; ; )
In-Reply-To: <20130328030351.GA2033@ram.oc3035372033.ibm.com>
References: <2987308.JNKpYDEnfV@deuteros> <20130328030351.GA2033@ram.oc3035372033.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 28 March 2013 11:03:51 Ram Pai wrote:
> I tried these commands on a 3.8.0-rc1+ kernel and did not find the
> problem. Is this on a recent kernel?

I am on Fedora 17 latest, but I've seen this problem with different kernels. 
Pretty sure from 3.5 something to 3.8 something. All Fedora flavoured. I will 
try vanilla soon.

What I am not sure is whether this behaviour was there from the start (on 
Fedora 17). I *think* it started to happen later on, which would mean a 
potential userland change somehow causes it.

Would that be at all possible with some mechanism?
 
> > Previously unmounting the recursive bind target would not unmount the
> > source, which to me looks like a more sensible outcome.
> 
> yes. it should not unless they are peer-mounts, which in your case is
> not.

What are these and how to create them?

Thanks,

Tvrtko

