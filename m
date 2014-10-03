Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaJCTu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 15:50:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58853 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJCTuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 15:50:54 -0400
Date: Fri, 03 Oct 2014 12:52:59 -0700 (PDT)
Message-Id: <20141003.125259.1940750405354043575.davem@davemloft.net>
To: herton@redhat.com
Cc: chien.yen@oracle.com, rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rmanes@redhat.com, dledford@redhat.com
Subject: Re: Small fixes/changes for RDS
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412200194-28902-1-git-send-email-herton@redhat.com>
References: <1412200194-28902-1-git-send-email-herton@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Oct 2014 12:50:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Herton R. Krzesinski" <herton@redhat.com>
Date: Wed,  1 Oct 2014 18:49:51 -0300

> I got a report of one issue within RDS (after investigation it was a double
> free), and I'm sending the fix (patch 3/3) which reporter said it works (no more
> WARNING triggered on a specially instrumented kernel). The report/test was done
> on a very old kernel (RHEL 5, 2.6.18 based with backports), but the problem the
> patch handles still exists and should not change. Besides that, while
> reviewing some of the code but being unable to reproduce with rds_tcp, I
> noticed two small improvements/fixes which are in patches 1 and 2.

Series applied, thanks.
