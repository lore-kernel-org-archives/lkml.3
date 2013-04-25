Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab3DYNuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:50:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26609 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab3DYNuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:50:15 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=oXbKA9ljmlQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=DY9HwZRBA4wA:10 a=20KFwNOVAAAA:8 a=T3S3pLq5Yr6Hla_MoSMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366897812.10248.15.camel@gandalf.local.home>
Subject: [STABLE] tracing: Fix selftest function recursion accounting
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Date: Thu, 25 Apr 2013 09:50:12 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Can you add this to the 3.8 stable tree. It's not applicable for earlier
kernels.

Thanks!

-- Steve

commit 05cbbf643b8eea1be21082c53cdb856d1dc6d765
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Jan 22 23:35:11 2013 -0500

    tracing: Fix selftest function recursion accounting


