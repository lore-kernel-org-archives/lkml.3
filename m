Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaCKPhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:37:38 -0400
Received: from mout.web.de ([212.227.15.4]:52698 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbaCKPhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:37:36 -0400
Date: Tue, 11 Mar 2014 16:37:25 +0100
From: Julian Wollrath <jwollrath@web.de>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "pebolle@tiscali.nl" <pebolle@tiscali.nl>
Subject: Re: [PATCH] PNPACPI: proper handling ACPI IO/Memory resources
Message-ID: <20140311163725.00db0a6e@ilfaris>
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926301203865@SHSMSX103.ccr.corp.intel.com>
References: <1394548827-15172-1-git-send-email-rui.zhang@intel.com>
	<744357E9AAD1214791ACBA4B0B90926301203865@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:LUQCz1RX1TCjsQPIiuKImnpF7GwoEf6EgO9DaOUXVpiMGwjs55+
 4yJPlBPJQcRR5u/hojhKBEEyTco+qDPmWa4lvb98WhOvgVX7TXLWCNeLXLLkLg2yi97uTon
 Eax3ZqjbjjVeNfaJW6w399I/Gq3YCDfWFSkmcaC0zqJeFrOyCH3F4y0x4EP+7CblW6iiiuf
 DWb12kceTufN2kjso4Kzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tue, 11 Mar 2014 14:50:42 +0000
schrieb "Zhang, Rui" <rui.zhang@intel.com>:
> Can you please check if this patch fixes the problem for you or not?
That patch fixes the problem, thank you. Feel free to add a 
Tested-by: Julian Wollrath <jwollrath@web.de>


Cheers,
Julian Wollrath
