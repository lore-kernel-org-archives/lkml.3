Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab3FSQPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:15:34 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39814 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab3FSQPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:15:33 -0400
Date: Wed, 19 Jun 2013 09:13:12 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, paulus@samba.org, acme@redhat.com,
        xiaoguangrong@linux.vnet.ibm.com, icycoder@gmail.com
Subject: Re: [PATCH 1/2] perf tools: fix a typo of a Power7 event name
Message-ID: <20130619161312.GA13326@us.ibm.com>
References: <1371633326-7696-1-git-send-email-runzhen@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371633326-7696-1-git-send-email-runzhen@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061916-7182-0000-0000-00000769A75F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Runzhen Wang [runzhen@linux.vnet.ibm.com] wrote:
| In the Power7 PMU guide:
| https://www.power.org/documentation/commonly-used-metrics-for-performance-analysis/
| PM_BRU_MPRED is referred to as PM_BR_MPRED.
| 
| This patch fix the typo by changing the name of the event in kernel and
| documentation accordingly.
| 
| Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>

Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

