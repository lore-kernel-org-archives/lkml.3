Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161310AbaDPVfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:35:01 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:33040 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbaDPVe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:34:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140416204433.GZ4496@linux.vnet.ibm.com>
References: <534EDBF4.6030702@gatech.edu> <534EDCC7.1040701@gatech.edu> <20140416204433.GZ4496@linux.vnet.ibm.com>
From: Pranith Kumar <pranith@gatech.edu>
Date: Wed, 16 Apr 2014 17:34:26 -0400
X-Google-Sender-Auth: CbW5Ox64qLu_OEXFXXP4FO8ebcc
Message-ID: <CAJhHMCD9rcyp07pWn7L1ojpv57ducYezCh-g25J3LfvuubJ_gQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] kernel/torture.c: unmark torture_init_* as __inline
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 4:44 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Good catch, queued for 3.16!  I missed it because of my habit of building
> the torture tests directly into the kernel rather than loading them
> as modules.  So thank you both for the patch and for your testing efforts!
>

You are welcome!

> Just out of curiosity, what are you thinking of using this for?
>

I am exploring RCU in my research, looking for ways to apply the ideas
to GPGPU and was studying the source code in the kernel. I will
hopefully be using this in the future.

(I should probably stick to userspace rcu :)

-- 
Pranith
