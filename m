Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3LCSLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:11:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22796 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab3LCSLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:11:07 -0500
Message-ID: <529E1F47.50107@oracle.com>
Date: Tue, 03 Dec 2013 13:13:27 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: tony.luck@intel.com, fenghua.yu@intel.com
CC: xen-devel <xen-devel@lists.xenproject.org>, linux-kernel@vger.kernel.org
Subject: IA64 on Xen support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony, Fenghua,


We had a discussion at the last Xen Summit about status of Linux' IA64 
Xen. Xen itself dropped IA64 support in 4.2 (it is approaching 4.4 now) 
and it's not clear whether we can even build Linux/Xen/IA64 against 
latest Xen sources, let alone run it.

The proposal at the summit was to remove Xen-related bits from IA64 in 
Linux. Any objections to this?


Thanks.
-boris


