Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab3E0BXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 21:23:09 -0400
Received: from mx12.netapp.com ([216.240.18.77]:2939 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab3E0BXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 21:23:08 -0400
X-IronPort-AV: E=Sophos;i="4.87,747,1363158000"; 
   d="scan'208";a="58212513"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Adamson, Andy" <William.Adamson@netapp.com>
Subject: Re: [PATCH 3.9-stable] NFSv4.1 Fix a pNFS session draining deadlock
Thread-Topic: [PATCH 3.9-stable] NFSv4.1 Fix a pNFS session draining deadlock
Thread-Index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkhkJMAAQyK0A
Date: Mon, 27 May 2013 01:23:05 +0000
Message-ID: <1369617780.15984.9.camel@leira.trondhjem.org>
References: <000001ce5a70$7b9bd410$72d37c30$%choi@samsung.com>
In-Reply-To: <000001ce5a70$7b9bd410$72d37c30$%choi@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <615722678DBD8F4FA24EACB184B6A677@hq.netapp.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 09:23 +0900, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

It's a condition which appears to be extremely rare: so far, we've only
seen it during extreme stress testing at NetApp. For that reason, and
because it is NFSv4.1 only, I'm inclined to wait until we see real-world
cases before making it a stable patch.

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
