Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaKDTxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:53:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58687 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKDTxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:53:23 -0500
Date: Tue, 04 Nov 2014 14:53:15 -0500 (EST)
Message-Id: <20141104.145315.548353349719796428.davem@davemloft.net>
To: shuahkh@osg.samsung.com
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org, mmarek@suse.cz,
        keescook@chromium.org, tranmanphong@gmail.com, dh.herrmann@gmail.com,
        hughd@google.com, bobby.prani@gmail.com, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 02/20] selftests/net: move test out of Makefile into a
 shell script
From: David Miller <davem@davemloft.net>
In-Reply-To: <51d57725e89809806bd8af5555af341296cc4dd7.1415117102.git.shuahkh@osg.samsung.com>
References: <cover.1415117102.git.shuahkh@osg.samsung.com>
	<cover.1415117102.git.shuahkh@osg.samsung.com>
	<51d57725e89809806bd8af5555af341296cc4dd7.1415117102.git.shuahkh@osg.samsung.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Nov 2014 11:53:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shuah Khan <shuahkh@osg.samsung.com>
Date: Tue,  4 Nov 2014 10:10:58 -0700

> Currently bpf test run from the Makefile. Move it out of the
> Makefile to be run from a shell script to allow the test to
> be run as stand-alone test, in addition to allowing the test
> run from a make target.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Acked-by: David S. Miller <davem@davemloft.net>
