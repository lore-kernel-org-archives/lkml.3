Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaCaEAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 00:00:18 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:55607 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750804AbaCaEAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 00:00:16 -0400
X-IronPort-AV: E=Sophos;i="4.97,762,1389715200"; 
   d="scan'208";a="28653195"
From: "gaofeng@cn.fujitsu.com" <gaofeng@cn.fujitsu.com>
To: Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>
Subject: Re: [PATCH for v3.14] AUDIT: Allow login in non-init namespaces
Thread-Topic: [PATCH for v3.14] AUDIT: Allow login in non-init namespaces
Thread-Index: Ac9MlbH9lxaePtDDQaOIt0mOvkSdVA==
Date: Mon, 31 Mar 2014 04:00:03 +0000
Message-ID: <917C359111529246A8AE877AF8038FAB620AF1@G08CNEXMBPEKD03.g08.fujitsu.local>
References: <1396220874.6974.5.camel@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.163]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 07:10 AM, Eric Paris wrote:
> In 3.15 we should have patches to support not only the non-init_net
> (3.14) namespace but also the non-init_pid and non-init_user namespace.
> So all will be right in the world. 

good news.
