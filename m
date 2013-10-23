Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3JWLwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:52:25 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:17302 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752742Ab3JWLwY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:52:24 -0400
From: "Bobniev, Roman" <Roman.Bobniev@sonymobile.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        =?iso-8859-1?Q?=22Andersson=2C_Bj=F6rn=22?= 
	<Bjorn.Andersson@sonymobile.com>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        "Bird, Tim" <Tim.Bird@sonymobile.com>, "cl@linux.com" <cl@linux.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Date: Wed, 23 Oct 2013 13:52:19 +0200
Subject: RE: [PATCH] slub: proper kmemleak tracking if CONFIG_SLUB_DEBUG
 disabled
Thread-Topic: [PATCH] slub: proper kmemleak tracking if CONFIG_SLUB_DEBUG
 disabled
Thread-Index: Ac7FItzBPYCJecDTTCSoKpynakCBGAKwa/eD
Message-ID: <F901C6708ADD5241BD39AFE3DD266906013746E21BDC@seldmbx01.corpusers.net>
References: <1381273137-14680-1-git-send-email-tim.bird@sonymobile.com>,<000001419e9e3e33-67807dca-e435-43ee-88bc-3ead54a83762-000000@email.amazonses.com>
In-Reply-To: <000001419e9e3e33-67807dca-e435-43ee-88bc-3ead54a83762-000000@email.amazonses.com>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, sv-SE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 8 Oct 2013, Tim Bird wrote:
> 
> > It also fixes a bug where kmemleak was only partially enabled in some
> > configurations.
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Could you help me, who the maintainer is that
puts this patch in a tree and pushes it to mainline?
Do we wait on some additional Ack from someone?

With best regards,
Roman.