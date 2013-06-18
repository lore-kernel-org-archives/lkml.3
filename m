Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3FREDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:03:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59718 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3FREDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:03:54 -0400
X-AuditID: cbfee691-b7fef6d000002d62-d5-51bfdc27e6fc
Message-id: <51BFDC27.4020102@samsung.com>
Date: Tue, 18 Jun 2013 13:03:51 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [GIT PULL] extcon for 3.11
References: <51BB0EF1.5090203@samsung.com> <20130617230119.GA27053@kroah.com>
 <20130617230309.GB27053@kroah.com>
In-reply-to: <20130617230309.GB27053@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkQFf9zv5AgwNrjCyaF69ns7jwtIfN
	4mzTG3aLy7vmsFncblzB5sDqsX/uGnaPvi2rGD2O39jO5PF5k1wASxSXTUpqTmZZapG+XQJX
	xpt/Z1kKjkpUPO54yN7A+FS4i5GTQ0LAROLmlj5GCFtM4sK99WxdjFwcQgJLGSWuXJoD5HCA
	Fe3vFIWIL2KUOPFmGwuE84JR4vGLFewg3bwCWhJrl0xlA7FZBFQlWh6fBJvKBhTf/+IGWFxU
	IExi5fQrLBD1ghI/Jt8Ds0UENCReHr0FNpRZYAGjxK2up8wgCWEBdYmbc3YzgdhCAkUSV98f
	YAS5iFNAX+LmE22QMLOAjsT+1mlsELa8xOY1b5lB5kgI7GOXeDcfYhmLgIDEt8mHWCC+kZXY
	dIAZ4mNJiYMrbrBMYBSbheSkWUjGzkIydgEj8ypG0dSC5ILipPQiU73ixNzi0rx0veT83E2M
	wMg6/e/ZxB2M9w9YH2JMBlo5kVlKNDkfGJl5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmk
	J5akZqemFqQWxReV5qQWH2Jk4uCUamDMtljEpfJmRm7lzHNmvu3cV3ieRd4Ndd6jllbg4PG3
	PG3XI3dhia/FhyQPfptg/v2sb2Pfk6/Rr4Qv/sk6uujn3NeNMbf6nFL5pzY8Fb947rLUgvsr
	LrQedudJnyXCfex9zJnJm2VeRb0yVDjPLeRx8cUZ0/Dz3Hc+pgbpJq2VNtv2UeK97n9GJZbi
	jERDLeai4kQAmxtMc8ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK76nf2BBttXalk0L17PZnHhaQ+b
	xdmmN+wWl3fNYbO43biCzYHVY//cNewefVtWMXocv7GdyePzJrkAlqgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoMVKCmWJOaVAoYDE4mIlfTtM
	E0JD3HQtYBojdH1DguB6jAzQQMIaxow3/86yFByVqHjc8ZC9gfGpcBcjB4eEgInE/k7RLkZO
	IFNM4sK99WxdjFwcQgKLGCVOvNnGAuG8YJR4/GIFO0gVr4CWxNolU9lAbBYBVYmWxycZQWw2
	oPj+FzfA4qICYRIrp19hgagXlPgx+R6YLSKgIfHy6C2wocwCCxglbnU9ZQZJCAuoS9ycs5sJ
	xBYSKJK4+v4AI8h1nAL6EjefaIOEmQV0JPa3TmODsOUlNq95yzyBUWAWkhWzkJTNQlK2gJF5
	FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw3D6T2sG4ssHiEKMAB6MSD2+C2P5AIdbEsuLK
	3EOMEhzMSiK8JWeAQrwpiZVVqUX58UWlOanFhxiTgSEwkVlKNDkfmFLySuINjU3MjCyNzA0t
	jIzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoHRUn2NgZCiT2jiOZO5NUwf++OaNvya
	bXlXJ+Jc1XzjU57FCvYdH7cs3sucan1cQPbzNrXvNfncTnrrw+3ffOhsvF0bInxRUOf/5Q/c
	gl8WcpisD5xw4M/1pg6jc3P8r1dtrdRbOXnKNV7fcE3eetVdV+Z+2Wb/nGm9693U95d+PtZX
	vbDxrn23EktxRqKhFnNRcSIAo0RQlh8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 08:03 AM, Greg KH wrote:
> On Mon, Jun 17, 2013 at 04:01:19PM -0700, Greg KH wrote:
>> On Fri, Jun 14, 2013 at 09:39:13PM +0900, Chanwoo Choi wrote:
>>> Hi Greg,
>>>
>>> First of all, I'm so sorry about previous wrong pull-request.
>>> I will be careful and not to make same mistakes
>>>
>>> This is extcon-next pull request for 3.11
>>> Please pull extcon with following updates.
>>>
>>> I combined the patch of small fix and new drivers becasue
>>> 3.10-rc version is large.
>>>
>>> Best Regards,
>>> Chanwoo Choi
>>>
>>> The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:
>>>
>>>   Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)
>>>
>>> are available in the git repository at:
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.11
>>>
>>> for you to fetch changes up to f7ae906806279e5b57bfd302b945e1bcdddce95b:
>>>
>>>   extcon: Add an API to get extcon device from dt node (2013-06-14 18:36:34 +0900)
>>>
>>> ----------------------------------------------------------------
>>> Update extcon for 3.11
>>>
>>> This patchset modify small fix of extcon core driver and add new extcon
>>> driver for Palmas device which is USB tranceiver device. Also, support
>>> OF helper API to get the name of extcon device(producer driver) on extcon
>>> consumer driver.
>>>
>>> Detailed description for patchset:
>>> 1. Modify extcon-class driver
>>> - Change permission 'state' sysfs entry(rw->r)
>>> - Use EXPORT_SYMBOL_GPL for exported functions
>>> - Fix bug null pointer when call extcon_unregister_interest
>>>
>>> 2. Modify Kconfig of extcon
>>> - Change the extcon config type to bool from module. If extcon
>>> is built as module and then extcon consumer driver uses API of,
>>> extcon, compiler happen "undefined reference to" build error.
>>>
>>> 3. Add new extcon driver for Palmas device and OF helper API
>>> - Add new extcon drvier for Palmas which is USB tranceiver device
>>> - Add OF(Open Firmware) Helper API which is of_extcon_get_extcon_dev()
>>>   This helper API get the extcon device name on extcon consumer device.
>>>
>>> ----------------------------------------------------------------
>>> Chanwoo Choi (1):
>>>       extcon: Change permission 'state' sysfs entry (rw -> r)
>>>
>>> Graeme Gregory (1):
>>>       extcon: Palmas Extcon Driver
>>>
>>> Jonghwa Lee (1):
>>>       extcon: class: Add NULL pointer checking for removing notifier block.
>>>
>>> Kishon Vijay Abraham I (3):
>>>       extcon: Kconfig: Make extcon config type as bool
>>
>> Why is this change made?  Why can't I have the extcon core as a module?
>> What changed to prevent this?
> 
> And hint, I know why you did this, and it's not the correct way, please
> fix it up properly...

OK, I fix this issue by using the following way:
- The extcon consumer driver must have the dependency of CONFIG_EXTCON
on consumer driver's Kconfig. If extcon core is built as module,
all of the extcon consumer driver will be built as moduel too.

Thanks for your comment.

Best Regards,
Chanwoo Choi


