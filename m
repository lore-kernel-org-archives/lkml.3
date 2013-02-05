Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3BEH0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:26:34 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58079 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3BEH0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:26:31 -0500
Message-ID: <5110B41D.3090605@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2013 15:26:21 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 0/3] KVM: MMU: simple cleanups
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020507-4790-0000-0000-000006C9A7EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are the simple cleanups for MMU, no function / logic changed.

Marcelo, Gleb, please apply them after applying
"[PATCH v3] KVM: MMU: lazily drop large spte"

Changelog:
no change, just split them from the previous patchset for good review.

Thanks!

