Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbaFBXxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:53:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29473 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaFBXxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:53:45 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-ce-538d0e862c5f
Message-id: <538D0E86.8080902@samsung.com>
Date: Tue, 03 Jun 2014 08:53:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] extcon next-v2 for v3.16
References: <538C06FC.4000009@samsung.com> <20140602225517.GB7641@kroah.com>
In-reply-to: <20140602225517.GB7641@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkWLeNrzfYoOGHnkXz4vVsFmeb3rBb
	XN41h83iduMKNgcWj/1z17B79G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8bkF/2MBXv4Kja0
	9LM1MD7m7mLk5JAQMJG4dfYTK4QtJnHh3nq2LkYuDiGBpYwSd859YIcpun34CjNEYjqjxNY3
	B6Gc14wS92dtZgOp4hXQkljcdJsJxGYRUJXY1rebBcRmA4rvf3EDrEZUIExi5fQrLBD1ghI/
	Jt8Ds0UENCReHr3FAjKUWaCdUeLkwRVgCWEBA4lNZ+YBbeMA2uYj8eZpPEiYU0BPYtfqM2C7
	mAV0JPa3TmODsOUlNq95C3achMA6dok1iy6zQBwkIPFt8iEWkDkSArISmw4wQ3wmKXFwxQ2W
	CYxis5CcNAvJ2FlIxi5gZF7FKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERhHp/89693BePuA
	9SHGZKCVE5mlRJPzgXGYVxJvaGxmZGFqYmpsZG5pRpqwkjhv0sOkICGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2MKVGSDW5hRy33KsbNXG7OY8hRPOeKnZfldGuz1CrxXc9MpExNWr5/Ft2t
	4JHT7MixQ7w75k686pp92ziueF9vt14peZLng9UdO4P96yelr2Fh+TkzhyU2iSvElyUoaPmk
	iWf3W655t/GVY9tPgT+nJz62aJsZdqw3xfP2e8G7LxYw+5l01lxWYinOSDTUYi4qTgQAt+ot
	fbkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xoG4bX2+wwe42TYvmxevZLM42vWG3
	uLxrDpvF7cYVbA4sHvvnrmH36NuyitHj8ya5AOaoBkabjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKB1SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9
	Q4LgeowM0EDCGsaMyS/6GQv28FVsaOlna2B8zN3FyMkhIWAicfvwFWYIW0ziwr31bF2MXBxC
	AtMZJba+OcgM4bxmlLg/azMbSBWvgJbE4qbbTCA2i4CqxLa+3SwgNhtQfP+LG2A1ogJhEiun
	X2GBqBeU+DH5HpgtIqAh8fLoLRaQocwC7YwSJw+uAEsICxhIbDozD2gbB9A2H4k3T+NBwpwC
	ehK7Vp8B28UsoCOxv3UaG4QtL7F5zVvmCYwCs5CsmIWkbBaSsgWMzKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxgqP0mfQOxlUNFocYBTgYlXh4Aw70BAuxJpYVV+YeYpTgYFYS4TX4BhTi
	TUmsrEotyo8vKs1JLT7EmAwMgYnMUqLJ+cAEklcSb2hsYmZkaWRuaGFkbE6asJI478FW60Ah
	gfTEktTs1NSC1CKYLUwcnFINjMyT162vdNT6o+z071ho0N6JWzlX2jRGTWllXDqxbs+d07uM
	+BdmH9+8dsN+/2m6L6efN+jbaZ6ScsyYofvLwiWqKxoLxB9Nbdz20fcWk6/voYxagxVL+Nat
	qItcvz53J8tE1mPRrT5n5hvNfTsz/Ym87+QpV1mqP6VeFnf+HLHtn7DQl745RguVWIozEg21
	mIuKEwGw6bh9FgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

On 06/03/2014 07:55 AM, Greg KH wrote:
> On Mon, Jun 02, 2014 at 02:09:16PM +0900, Chanwoo Choi wrote:
>> Dear Greg,
>>
>> This is extcon-next-v2 full request for v3.16. This pull request includes
>> additional patchset after merged previous extcon-next pull request(tags/extcon-next-for-v3.16).
>> I add detailed description of this pull request on below. Please pull extcon with following update.
>>
>> Best Regards,
>> Chanwoo Choi
>>
>> The following changes since commit 3f79a3fb5f41e8f2229e5bf8aa725eaa79686f14:
>>
>>   extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev (2014-04-29 09:52:12 +0900)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-v2-for-3.16
> 
> I was thinking it was too late for 3.16-rc1, as the merge window is now
> open and I like to have things in my tree a week or so before that
> happens, but I figured this was nice and self-contained so I would take
> it.

Sorry late pull-request. I'll send next pull-request before -rc7 release certainly.

> 
> So I pulled, and built, and then got this:
> 
> ERROR: "regmap_irq_get_virq" [drivers/extcon/extcon-sm5502.ko] undefined!
> ERROR: "regmap_add_irq_chip" [drivers/extcon/extcon-sm5502.ko] undefined!
> ERROR: "regmap_del_irq_chip" [drivers/extcon/extcon-sm5502.ko] undefined!
> 
> which makes me know that you haven't done much build testing of the code
> :(

Sorry about this mistake. As you comment, I'll check much build testing.

> 
> So I can't take this now, sorry, please fix it up and make it ready for
> 3.17.  If you have bugfixes for 3.16, feel free to send them in a
> separate pull request...

OK, I'll fix it and send pull-requesst for 3.17.
Thanks for your comment.

Best Regards,
Chanwoo Choi


