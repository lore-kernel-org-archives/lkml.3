Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbaDPXLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:11:15 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55468 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbaDPXLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:11:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140416211407.GA4496@linux.vnet.ibm.com>
References: <534EEC6B.8030500@gatech.edu> <20140416211407.GA4496@linux.vnet.ibm.com>
From: Pranith Kumar <pranith@gatech.edu>
Date: Wed, 16 Apr 2014 19:10:41 -0400
X-Google-Sender-Auth: FwH1j54Ekhr2zTu5rCxeyh6OiM4
Message-ID: <CAJhHMCBU+u6vmc+vjLCGrSytb74MmpgBCvMZVvR7o9k=3vgchA@mail.gmail.com>
Subject: Re: [PATCH 2/2] kernel/rcu/rcutorture.c: use macro to define module parameter
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 5:14 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> This fails for me.  The problem is that the defined macro makes everything
> static, and rcutorture_runnable is used in kernel/sysctl.c.  :-/
>
> In theory, it would be possible to make torture_param() take "static"
> as a parameter, but this adds more characters than it removes.
>

Oh, I just tried building it as a module and it worked. In the future
I will run this both as inbuilt and as a module before sending any
patches.

Sorry for the noise!


-- 
Pranith
