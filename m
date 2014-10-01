Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaJAVuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:50:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbaJAVt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:49:58 -0400
From: "Herton R. Krzesinski" <herton@redhat.com>
To: Chien Yen <chien.yen@oracle.com>
Cc: rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        rmanes@redhat.com, dledford@redhat.com
Subject: Small fixes/changes for RDS
Date: Wed,  1 Oct 2014 18:49:51 -0300
Message-Id: <1412200194-28902-1-git-send-email-herton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got a report of one issue within RDS (after investigation it was a double
free), and I'm sending the fix (patch 3/3) which reporter said it works (no more
WARNING triggered on a specially instrumented kernel). The report/test was done
on a very old kernel (RHEL 5, 2.6.18 based with backports), but the problem the
patch handles still exists and should not change. Besides that, while
reviewing some of the code but being unable to reproduce with rds_tcp, I
noticed two small improvements/fixes which are in patches 1 and 2.

thanks,
--
[]'s
Herton
