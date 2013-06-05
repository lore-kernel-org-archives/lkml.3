Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3FECwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 22:52:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11304 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3FECwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:52:45 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-cf-51aea7fb3c94
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <51AEA80B.8030008@samsung.com>
Date: Wed, 05 Jun 2013 11:52:59 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
To: dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [RFC][PATCH 0/2] dma-buf: add importer private data for reimporting
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
 <CAKMK7uHYLG3iNphE+g4BBB-LuUM67NRvbQPBvCHE2FN71-GLnA@mail.gmail.com>
 <51A879E0.3080106@samsung.com> <20130531152956.GX15743@phenom.ffwll.local>
 <51ADC48E.80907@samsung.com> <20130604125558.GB15743@phenom.ffwll.local>
In-reply-to: <20130604125558.GB15743@phenom.ffwll.local>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsWyRsSkSPf38nWBBrf6jCx6z51ksrjy9T2b
	xaT7E1gszja9Ybf4cuUhk8XlXXPYLHo2bGW1OHX3M7vFjMkv2Rw4Pe5c28Pmsf3bA1aP+93H
	mTxu/3vM7NG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZ0ze8ZCo4aVMxZXILawPjIsMuRk4O
	CQETiSPNS5ghbDGJC/fWs3UxcnEICSxllNj29yojTNH6P+0sEIlFjBJX9s5nB0nwCghK/Jh8
	jwXEZhZQl5g0bxEzhC0i0dKxgRXC1pZYtvA1M0TzC0aJT9fnMUE0a0k8/XERrIFFQFXi2tLn
	YA1sAuYSnR8vsYHYQgIKElcmHgNaxsEhKhAmsXNzOsgcEYGNzBKtdyeD1QgLBEgsX30BasFS
	Jonmy9/AzuYUsJDonHAU7GwJga/sEr0TmqG2CUh8m3yIBWSqhICsxKYDUP9LShxccYNlAqP4
	LCTPzULy3Cwkz81C8twCRpZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIGRfPrfswk7GO8d
	sD7EmAy0fiKzlGhyPjAR5JXEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qB0eHNpvuvDx1zuBiwfInE+mkboxc+eDujevLNRSxGOqyHn7o4GagccbDR
	8JoSc6xz9nl/IX+XmOAZGs9c3OI7C9w5Jj5snPt6gdmqO+Vv3z3wL4ne6hgZojknQPY+49M5
	79vPxNVIzC8XShGpfSGzjnGea3Lfha1/d2kc2TE1jaF+T+v7GpNt6kosxRmJhlrMRcWJAF4x
	DHP6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd3fy9cFGmyarmHRe+4kk8WVr+/Z
	LCbdn8BicbbpDbvFlysPmSwu75rDZtGzYSurxam7n9ktZkx+yebA6XHn2h42j+3fHrB63O8+
	zuRx+99jZo++LasYPT5vkgtgi2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBX
	UshLzE21VXLxCdB1y8wBOktJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjD
	mLH0y1bmguvWFR+/zGRqYNxg0MXIySEhYCKx/k87C4QtJnHh3nq2LkYuDiGBRYwSV/bOZwdJ
	8AoISvyYfA+oiIODWUBe4silbJAws4C6xKR5i5gh6l8wSny6Po8Jol5L4umPi8wgNouAqsS1
	pc9ZQWw2AXOJzo+X2EBsIQEFiSsTj7GDzBQVCJPYuTkdZI6IwEZmida7k8FqhAUCJJavvgC1
	YCmTRPPlb4wgCU4BC4nOCUdZJjAKzEJy3yyE+2YhuW8BI/MqRtHUguSC4qT0XCO94sTc4tK8
	dL3k/NxNjOCYfya9g3FVg8UhRgEORiUe3gef1gYKsSaWFVfmHmKU4GBWEuENTVgXKMSbklhZ
	lVqUH19UmpNafIgxGei7icxSosn5wHSUVxJvaGxiZmRpZG5oYWRsTpqwkjjvwVbrQCGB9MSS
	1OzU1ILUIpgtTBycUg2MmnG3bF69+f39bp39Io8GllJxbY7jCjMN27ct+fX8DvP3RQpzF8bx
	Pn/2Ysr/7bqLl83OrWB1eFalbNOwYOOV1AniXAy1l47/tPEuPcr20Xrb0yWrt73omnTgluHR
	f+cTuOou3d/6PZuzVTdllcGlvV9/uZWVPvHy97FOv7j7wqGIJVtrn29QtlBiKc5INNRiLipO
	BADXtCoDPQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2013년 06월 04일 21:55, Daniel Vetter wrote:
> On Tue, Jun 04, 2013 at 07:42:22PM +0900, 김승우 wrote:
>>
>>
>> On 2013년 06월 01일 00:29, Daniel Vetter wrote:
>>> On Fri, May 31, 2013 at 07:22:24PM +0900, 김승우 wrote:
>>>> Hello Daniel,
>>>>
>>>> Thanks for your comment.
>>>>
>>>> On 2013년 05월 31일 18:14, Daniel Vetter wrote:
>>>>> On Fri, May 31, 2013 at 10:54 AM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
>>>>>> importer private data in dma-buf attachment can be used by importer to
>>>>>> reimport same dma-buf.
>>>>>>
>>>>>> Seung-Woo Kim (2):
>>>>>>   dma-buf: add importer private data to attachment
>>>>>>   drm/prime: find gem object from the reimported dma-buf
>>>>>
>>>>> Self-import should already work (at least with the latest refcount
>>>>> fixes merged). At least the tests to check both re-import on the same
>>>>> drm fd and on a different all work as expected now.
>>>>
>>>> Currently, prime works well for all case including self-importing,
>>>> importing, and reimporting as you describe. Just, importing dma-buf from
>>>> other driver twice with different drm_fd, each import create its own gem
>>>> object even two import is done for same buffer because prime_priv is in
>>>> struct drm_file. This means mapping to the device is done also twice.
>>>> IMHO, these duplicated creations and maps are not necessary if drm can
>>>> find previous import in different prime_priv.
>>>
>>> Well, that's imo a bug with the other driver. If it doesn't export
>>> something really simple (e.g. contiguous memory which doesn't require any
>>> mmio resources at all) it should have a cache of exported dma_buf fds so
>>> that it hands out the same dma_buf every time.
>>
>> Hm, all existing dma-buf exporter including i915 driver implements its
>> map_dma_buf callback as allocating scatter-gather table with pages in
>> its buffer and calling dma_map_sg() with the sgt. With different
>> drm_fds, importing one dma-buf *twice*, then importer calls
>> dma_buf_attach() and dma_buf_map_attachment() twice at least in drm
>> importer because re-importing case can only checked with prime_priv in
>> drm_file as I described.
> 
> Well, but thanks to all the self-import and re-import checks, it's
> _impossible_ to import the same dma_buf twice without noticing (presuming
> both importer and exporter are drm devices).

No, it is possible. Prime function, drm_gem_prime_fd_to_handle(), checks
re-import with following code.

ret = drm_prime_lookup_buf_handle(&file_priv->prime,
		dma_buf, handle);

Unfortunately, file_priv is allocated per each open of drm node so this
code can only find re-import within same drm open context.

And driver specific import functions, like drm_gem_prime_import(), only
check self-import like following code.

if (dma_buf->ops == &drm_gem_prime_dmabuf_ops) {
	obj = dma_buf->priv;
	if (obj->dev == dev) {
		/* ... */
	}
}

This means some application like following can make re-import to
different gem objects.

int drm_fd1, drm_fd2, ret;
int dma_buf_fd;
struct drm_prime_handle prime1, prime2;

drm_fd1 = open(DRM_NODE, O_RDWR, 0);
drm_fd2 = open(DRM_NODE, O_RDWR, 0);

/* get some dma-buf_fd from other dma-buf exporter */
prime1.fd = dma_buf_fd;
prime2.fd = dma_buf_fd;

ret = ioctl(drm_fd1, DRM_IOCTL_PRIME_FD_TO_HANDLE, &prime1);
ret = ioctl(drm_fd2, DRM_IOCTL_PRIME_FD_TO_HANDLE, &prime2);

This will import same dma-buf twice as different GEM object because
above checking codes can not check already imported gem object from the
dma-buf.

>>
>>>
>>> Or it needs to be more clever in it's dma_buf_attachment_map functions and
>>> lookup up a pre-existing iommu mapping.
>>>
>>> But dealing with this in the importer is just broken.
>>>
>>>>> Second, the dma_buf_attachment is _definitely_ the wrong place to do
>>>>> this. If you need iommu mapping caching, that should happen at a lower
>>>>> level (i.e. in the map_attachment callback somewhere of the exporter,
>>>>> that's what the priv field in the attachment is for). Snatching away
>>>>> the attachement from some random other import is certainly not the way
>>>>> to go - attachements are _not_ refcounted!
>>>>
>>>> Yes, attachments do not have refcount, so importer should handle and drm
>>>> case in my patch, importer private data is gem object and it has, of
>>>> course, refcount.
>>>>
>>>> And at current, exporter can not classify map_dma_buf requests of same
>>>> importer to same buffer with different attachment because dma_buf_attach
>>>> always makes new attachments. To resolve this exporter should search all
>>>> different attachment from same importer of dma-buf and it seems more
>>>> complex than importer private data to me.
>>>>
>>>> If I misunderstood something, please let me know.
>>>
>>> Like I've said above, just fix this in the exporter. If an importer sees
>>> two different dma_bufs it can very well presume that it those two indeed
>>> point to different backing storage.
>>
>> Yes, my patch does not break this concept. I just fixed case importing
>> _one_ dma-buf twice with different drm_fds.
> 
> See above, if you have two different struct file * for the same underlying
> buffer object something is wrong already.

drm_fds, I described, are not dma-buf fd but fds from opening DRM_NODE.

> 
>>> This will be even more important if we attach fences two dma_bufs. If your
>>> broken exporter creates multiple dma_bufs each one of them will have their
>>> own fences attached, leading to a complete disasters. Ok, strictly
>>> speaking if you keep the same reservation pointer for each dma_buf it'll
>>> work, but that's just a detail of how you solve this in the exporter.
>>
>> I can not understand about broken exporter you addressed. I don't mean
>> exporter makes dma-bufs from one backing storage.
>> While, my patch prevents not to create drm gem objects from one back
>> storage by importing one dma-buf with different drm-fds.
> 
> Well, we also have code in drm prime for that case - if the same dma_buf
> object shows up multiple times, we'll only import it once. For the second
> import we'll return the already created drm_gem object from the first
> import, but with the refcount incremented.

I already describe import check code above and it can cause different
gem objects from one dma-buf even it works well to access real buffer.

> 
>> I do not believe the fix of importer is the best way, but at this
>> moment, I have no idea how I can fix the exporter for this issue.
> 
> I think if you have drm prime drivers both as importers and exporters, it
> is already fixed. It is correct though that both importer and exporter
> need a bit of code to take care and not accidentally duplicate a shared
> object somehow.

Dave's prime reference patch v6 fixes that junk prime handle remains in
&file_priv->prime after dma-buf is released and import/export
information is cleared to increase dma-buf f_count for each
&file_priv->prime. But issue I described still remains.

> 
> But since you've proposed your rfc as part of the drm subsystem I've
> figured that we don't need to discuss the duplicate import handling code.

IMHO, considering current state of DRM PRIME, we need to discuss about
duplicate import handling. As I already wrote, I do not believe importer
private data is the best way to resolve this. So if you have better
solution, please let me know.

Thanks and Regards,
- Seung-Woo Kim

> 
> Yours, Daniel
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

