Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaFDQgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:36:23 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:55965 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaFDQgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140604163334.GA21501@infradead.org>
References: <538F331F.60101@kernel.dk>
	<20140604145803.GA7826@infradead.org>
	<538F34FB.7050003@kernel.dk>
	<20140604153159.GA27096@infradead.org>
	<CACVXFVNNTPrq29eS9GzJDequtFXCTNWPLJfzB4Z-XJVE5j8+aA@mail.gmail.com>
	<538F3FB5.2020102@kernel.dk>
	<CACVXFVM-aJwBgrvgT-nNbbi81vE4qeS1LgsS5cFGiz5cbsApZw@mail.gmail.com>
	<538F44AD.4090906@kernel.dk>
	<CACVXFVOxx973ho9yN0W95YCj2XQBoYqyu4aD4bZ_9Pv89XGgnQ@mail.gmail.com>
	<538F4938.7040309@kernel.dk>
	<20140604163334.GA21501@infradead.org>
Date: Thu, 5 Jun 2014 00:36:20 +0800
Message-ID: <CACVXFVNmRt_V7NtECfcg5VvJ8tNi-_3Vwg-FUJd3=fTn2tb6Yg@mail.gmail.com>
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf3071cf80758c9d04fb053a4d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3071cf80758c9d04fb053a4d
Content-Type: text/plain; charset=UTF-8

On Thu, Jun 5, 2014 at 12:33 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jun 04, 2014 at 10:28:40AM -0600, Jens Axboe wrote:
>> > Attachment patch should be enough.
>>
>> Yep, looks fine. Care to send as a proper patch, then I will include it?
>
> I think we an also drop the assignment to q->flush_rq->cmd_flags in
> flush_end_io now.
>

Yes, that is already done, :-)

Jens, attachment is the formal one, thanks.

Thanks,
-- 
Ming Lei

--20cf3071cf80758c9d04fb053a4d
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-block-mq-flush-clear-flush_rq-s-tag-in-flush_end_io.patch"
Content-Disposition: attachment; 
	filename="0001-block-mq-flush-clear-flush_rq-s-tag-in-flush_end_io.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hw0uwvjo0

RnJvbSA3N2ViMmU5Njk0MmRlZWQ1MjhiMmU1ODkyYTdkOWFhMzczNWMwYzY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaW5nIExlaSA8dG9tLmxlaW1pbmdAZ21haWwuY29tPgpEYXRl
OiBUaHUsIDUgSnVuIDIwMTQgMDA6MjM6NTUgKzA4MDAKU3ViamVjdDogW1BBVENIXSBibG9jazog
bXEgZmx1c2g6IGNsZWFyIGZsdXNoX3JxJ3MgdGFnIGluIGZsdXNoX2VuZF9pbygpCgpTbyB0aGF0
IGJsa19tcV90YWdfdG9fcnEoKSBjYW4gZGVjaWRlIGlmIG9uZSByZXF1ZXN0CmlzIGZsdXNoX3Jx
IGJ5IGNvbXBhcmluZyB0aGUgdGFnLgoKU2lnbmVkLW9mZi1ieTogTWluZyBMZWkgPHRvbS5sZWlt
aW5nQGdtYWlsLmNvbT4KLS0tCiBibG9jay9ibGstZmx1c2guYyB8ICAgIDIgKy0KIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2Jsb2Nr
L2Jsay1mbHVzaC5jIGIvYmxvY2svYmxrLWZsdXNoLmMKaW5kZXggZmY4N2M2Ni4uOGZmZWU0YiAx
MDA2NDQKLS0tIGEvYmxvY2svYmxrLWZsdXNoLmMKKysrIGIvYmxvY2svYmxrLWZsdXNoLmMKQEAg
LTIyNSw3ICsyMjUsNyBAQCBzdGF0aWMgdm9pZCBmbHVzaF9lbmRfaW8oc3RydWN0IHJlcXVlc3Qg
KmZsdXNoX3JxLCBpbnQgZXJyb3IpCiAKIAlpZiAocS0+bXFfb3BzKSB7CiAJCXNwaW5fbG9ja19p
cnFzYXZlKCZxLT5tcV9mbHVzaF9sb2NrLCBmbGFncyk7Ci0JCXEtPmZsdXNoX3JxLT5jbWRfZmxh
Z3MgPSAwOworCQlxLT5mbHVzaF9ycS0+dGFnID0gLTE7CiAJfQogCiAJcnVubmluZyA9ICZxLT5m
bHVzaF9xdWV1ZVtxLT5mbHVzaF9ydW5uaW5nX2lkeF07Ci0tIAoxLjcuOS41Cgo=
--20cf3071cf80758c9d04fb053a4d--
