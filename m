Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaI3Kli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:41:38 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56551 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaI3Klg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:41:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Michael Neuling <mikey@neuling.org>, greg@kroah.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        imunsie@au.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, anton@samba.org
Subject: Re: [PATCH v2 03/17] powerpc/cell: Make spu_flush_all_slbs() generic
Date: Tue, 30 Sep 2014 12:40:47 +0200
Message-ID: <2075902.qYMJnrEVUR@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412073306-13812-4-git-send-email-mikey@neuling.org>
References: <1412073306-13812-1-git-send-email-mikey@neuling.org> <1412073306-13812-4-git-send-email-mikey@neuling.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WXeQAR2ccE5puJVZdEpJ7I0MOMCznhZTXP9hwjmgClN
 Lk8nKOI5/4dIJcgLXM0WTTlLLMdMyoFH8n59IaSibRNtD8TcmU
 P/7oa4u8SEIqKf0VX917PbFIplpWH49ytuG4HItmtqk8eP+bJz
 ywHdjcNsX244PTff8wR05DT9U366slCVanGVfcADlTTX1A8/rK
 UoQ+u4e07nvzo4h4W4CSpZCfzv1ZWQcm9d3pbHD+Nw7Jw8Rr+X
 FwplxnR2tvp0rD5QbliQ9KwcyMkeTvEuL5yWG07IJcXAv5feFb
 eVA0IZjv9qQ21dfpMEpNVOGk20oFWfQXLPSB2c1DNwX79M56IH
 oN9gX0/HowKLwF0ne4qo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 20:34:52 Michael Neuling wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> This moves spu_flush_all_slbs() into a generic call copro_flush_all_slbs().
> 
> This will be useful when we add cxl which also needs a similar SLB flush call.
> 
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> 

Very nice!

Acked-by: Arnd Bergmann <arnd@arndb.de>
