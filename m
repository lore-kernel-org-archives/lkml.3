Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaDUSJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:09:24 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:47391 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaDUSJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140421155055.GU4496@linux.vnet.ibm.com>
References: <53546158.3020906@gmail.com> <20140421155055.GU4496@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 21 Apr 2014 14:08:48 -0400
Message-ID: <CAJhHMCAcahHKaXvCVZL51aUhdiejT_T5-vqJ+08D40HrH3cS_A@mail.gmail.com>
Subject: Re: [PATCH 1/1] rcu: cleanup: make rcutorture specific definitions
 depend on config value
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 11:50 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Good observation, but this approach prevents someone from building an
> rcutorture module after the fact for a kernel that was built with
> CONFIG_RCU_TORTURE_TEST=n.  So I have to say "no" on this one.
>

OK, I did not consider that case!  I will keep my eyes open while
studying the code.

Regards,
-- 
Pranith
