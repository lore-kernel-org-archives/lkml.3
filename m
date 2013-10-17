Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab3JQJLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:11:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34967 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3JQJL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:11:28 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <525FA980.4090102@jp.fujitsu.com>
Date: Thu, 17 Oct 2013 18:10:24 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "kexec@lists.infradead.org" <kexec@lists.infradead.org>
CC: ahonig@google.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Dave Anderson <anderson@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, keescook@google.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: kexec cannot find text map area if kaslr is enabled
References: <525FA702.5070805@jp.fujitsu.com>
In-Reply-To: <525FA702.5070805@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/17 17:59), HATAYAMA Daisuke wrote:
> Hello,
>
> I tried to use x86/kaslr branch to check if how it works with kdump framework.
>

Sorry, it's a branch of tip repository here:

http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=x86/kaslr

-- 
Thanks.
HATAYAMA, Daisuke

