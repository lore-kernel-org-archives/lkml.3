Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaJLLuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:50:22 -0400
Received: from fep14.mx.upcmail.net ([62.179.121.34]:56818 "EHLO
	fep14.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaJLLuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:50:15 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <543A6AF3.8020702@odi.ch>
Date: Sun, 12 Oct 2014 13:50:11 +0200
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net] x86: bpf_jit: fix two bugs in eBPF JIT compiler
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Fixes: 622582786c9e ("net: filter: x86: internal BPF JIT")

Hi, I confirm that this fixes my kernel panic when using nmap as root on 3.17.

Ortwin
