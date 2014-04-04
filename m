Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaDDOmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:42:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52133 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaDDOmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:42:50 -0400
Date: Fri, 04 Apr 2014 10:44:26 -0400 (EDT)
Message-Id: <20140404.104426.2226769084775433079.davem@davemloft.net>
To: luis.henriques@canonical.com
Cc: sasha.levin@oracle.com, chien.yen@oracle.com, rds-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rds: prevent dereference of a NULL device in
 rds_iw_laddr_check
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140404143136.GA2593@hercules>
References: <1396139975-5314-1-git-send-email-sasha.levin@oracle.com>
	<20140331.162607.153228065356865845.davem@davemloft.net>
	<20140404143136.GA2593@hercules>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Apr 2014 07:42:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luís Henriques <luis.henriques@canonical.com>
Date: Fri, 4 Apr 2014 15:31:36 +0100

> Could you please queue this one for stable as well?  (Looks like it even
> has CVE-2014-2678 assigned to it.)

Done.
