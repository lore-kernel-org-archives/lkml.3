Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaK0JGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:06:13 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:16179 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbaK0JGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:06:09 -0500
From: Anish Bhatt <anish@chelsio.com>
To: "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yann.morin.1998@free.fr" <yann.morin.1998@free.fr>
Subject: RE: [PATCH] Fix -Wmaybe-uninitialized warning seen with make
 menuconfig
Thread-Topic: [PATCH] Fix -Wmaybe-uninitialized warning seen with make
 menuconfig
Thread-Index: AQHQCg8B5HYD06Y25kG1hXtGVSrJ3px0LhKy
Date: Thu, 27 Nov 2014 09:06:05 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D8D8D486@nice.asicdesigners.com>
References: <1417071268-9422-1-git-send-email-anish@chelsio.com>
In-Reply-To: <1417071268-9422-1-git-send-email-anish@chelsio.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.163.160]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aah, ignore this please. Somehow I missed the two other recent mail chains
about this very thing, and my patch only covers part of it anyways.