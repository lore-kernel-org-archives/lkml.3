Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3F3Xz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 19:55:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37441 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3F3Xz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 19:55:57 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51D0C500.4060108@jp.fujitsu.com>
Date: Mon, 01 Jul 2013 08:53:36 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maxim Uvarov <muvarov@gmail.com>
CC: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>, riel@redhat.com,
        kexec@lists.infradead.org, hughd@google.com,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com, vgoyal@redhat.com,
        linux-mm@kvack.org, zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        walken@google.com, cpw@sgi.com, jingbai.ma@hp.com
Subject: Re: [PATCH v8 9/9] vmcore: support mmap() on /proc/vmcore
References: <20130523052421.13864.83978.stgit@localhost6.localdomain6> <20130523052547.13864.83306.stgit@localhost6.localdomain6> <20130523152445.17549682ae45b5aab3f3cde0@linux-foundation.org> <CAJGZr0LwivLTH+E7WAR1B9_6B4e=jv04KgCUL_PdVpi9JjDpBw@mail.gmail.com> <51A2BBA7.50607@jp.fujitsu.com> <CAJGZr0LmsFXEgb3UXVb+rqo1aq5KJyNxyNAD+DG+3KnJm_ZncQ@mail.gmail.com> <51A71B49.3070003@cn.fujitsu.com> <CAJGZr0Ld6Q4a4f-VObAbvqCp=+fTFNEc6M-Fdnhh28GTcSm1=w@mail.gmail.com> <20130603174351.d04b2ac71d1bab0df242e0ba@mxc.nes.nec.co.jp> <CAJGZr0+9VUweN1Ssdq6P9Lug1GnTB3+RPv77JLRmnw=rpd9+Dw@mail.gmail.com>
In-Reply-To: <CAJGZr0+9VUweN1Ssdq6P9Lug1GnTB3+RPv77JLRmnw=rpd9+Dw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/29 1:40), Maxim Uvarov wrote:
> Did test on 1TB machine. Total vmcore capture and save took 143 minutes while vmcore size increased from 9Gb to 59Gb.
>
> Will do some debug for that.
>
> Maxim.

Please show me your kdump configuration file and tell me what you did in the test and how you confirmed the result.

-- 
Thanks.
HATAYAMA, Daisuke

