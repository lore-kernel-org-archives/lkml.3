Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203Ab3DZJTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:19:12 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:22543 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759060Ab3DZJTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:19:11 -0400
From: Anurup m <anurup.m@huawei.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'David Howells'" <dhowells@redhat.com>, Lizefan <lizefan@huawei.com>,
        shyju pv <shyju.pv@huawei.com>, Sanil kumar <sanil.kumar@huawei.com>,
        Nataraj m <nataraj.m@huawei.com>
Subject: RE: [ PATCH ] Memory leak fix for bug 57101.
Thread-Topic: [ PATCH ] Memory leak fix for bug 57101.
Thread-Index: AQHOQahxzqL9KVVou0O8Lql76ItKRZjm8y9Q///qbQCAAVZV0A==
Date: Fri, 26 Apr 2013 09:18:19 +0000
Message-ID: <D2393EB95A9993478029A6FE6A290A9F15F51617@szxeml510-mbx.china.huawei.com>
References: <D2393EB95A9993478029A6FE6A290A9F15F504C9@szxeml510-mbx.china.huawei.com>
	<5179140B.3060002@huawei.com>
	<D2393EB95A9993478029A6FE6A290A9F15F50787@szxeml510-mbx.china.huawei.com>
 <20130425132900.6e2374afb4997b14d93232ac@linux-foundation.org>
In-Reply-To: <20130425132900.6e2374afb4997b14d93232ac@linux-foundation.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.18.96.95]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please find the Signed-off-by for my patch.
 
Signed-off-by: Anurup m <anurup.m@huawei.com>

Regards,
Anurup M

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: 2013年4月26日 1:59
To: Anurup m
Cc: 'linux-kernel@vger.kernel.org'; 'David Howells'; Lizefan; shyju pv; Sanil kumar; Nataraj m
Subject: Re: [ PATCH ] Memory leak fix for bug 57101.

On Thu, 25 Apr 2013 13:49:12 +0000 Anurup m <anurup.m@huawei.com> wrote:

> Resending the patch as Plain text, with no mangled tabs.

Please send us a Signed-off-by: for this, as described in
Documentation/SubmittingPatches, thanks.

