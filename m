Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaAQMlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:41:13 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:43524 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbaAQMlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:41:11 -0500
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTsoft Software Development Center
To: "=?utf-8?q?=E2=80=9Ctiejun=2Echen=E2=80=9D?=" 
	<tiejun.chen@windriver.com>
Subject: Re: powerpc/hugetlb: BUG: using smp_processor_id() in preemptible
Date: Fri, 17 Jan 2014 16:41:02 +0400
User-Agent: KMail/1.9.9
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Alexey Lugovskoy <lugovskoy@dev.rtsoft.ru>
References: <201401171323.52657@blacky.localdomain> <52D8F960.6030107@windriver.com>
In-Reply-To: <52D8F960.6030107@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201401171641.04553@blacky.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you try this?
>
> powerpc/hugetlb: replace __get_cpu_var with get_cpu_var
>
> Replace __get_cpu_var safely with get_cpu_var to avoid
> the following call trace:

Confirmed, no more acktraces.

Nikita
