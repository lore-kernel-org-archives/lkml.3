Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbaHZGrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:47:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62531 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbaHZGrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:47:47 -0400
X-AuditID: cbfee691-f79546d0000011a1-30-53fc2d9189d3
Message-id: <53FC2D91.3020103@samsung.com>
Date: Tue, 26 Aug 2014 15:47:45 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH 15/15] drm/exynos/fimc: fix source buffer registers
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
 <1408693946-15456-16-git-send-email-a.hajda@samsung.com>
 <53FC21DF.1010504@samsung.com> <53FC2AA1.7030605@samsung.com>
In-reply-to: <53FC2AA1.7030605@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkWHei7p9gg/erhCxurTvHanHl63s2
	i0n3J7BYvLh3kcXibNMbdovLu+awWcw4v4/JYu2Ru+wWMya/ZHPg9LjffZzJo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDK+LupkKWgWrdj6ZBJ7A+MkwS5GTg4JAROJddN/M0LYYhIX7q1n
	A7GFBJYySiyaEdjFyAFWc+pPQBcjF1B4EaPE86sboWpeMUr8vVUIYvMKaEmcW3uYFcRmEVCV
	mDz7LDOIzSagJ3Fn23EmEFtUIETizfF2doh6QYkfk++xgNgiAh4S89/sAatnFjjDJPF1vS6I
	LSzgLvF1w2ZmiMX7GCUm//rJBnIQp4C2ROdEQxCTGWj+/YtaEK3yEpvXvAUrlxC4xC4xbeU6
	doh7BCS+TT7EAvGLrMSmA8wQ70pKHFxxg2UCo9gsJBfNQpg6C8nUBYzMqxhFUwuSC4qT0otM
	9YoTc4tL89L1kvNzNzEC4+30v2cTdzDeP2B9iFGAg1GJh/dG/O9gIdbEsuLK3EOMpkBHTGSW
	Ek3OB0Z1Xkm8obGZkYWpiamxkbmlmZI4r470z2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jEuXr2IX5vofevvlah3HI8ohl1bVXtVmlRRYJr0vcvcvJh9vfnXLrxddIv8pBESGODc3TmKa
	P2GJUrLfU17P3BbFqQf4fTfZnxS4InKvpvv3NfvA29VK3lv0LZrTMkV9j2Q7cvx68qTfsPvH
	5P0+C6xq/359IDnhWEm6FO9LlsK7u1a90SpfocRSnJFoqMVcVJwIAGmw3tSyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAd2Jun+CDX7e47K4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2COamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8XVRJ0tBs2jF1ieT2BsY
	Jwl2MXJwSAiYSJz6E9DFyAlkiklcuLeerYuRi0NIYBGjxPOrG9lAEkICrxgl/t4qBLF5BbQk
	zq09zApiswioSkyefZYZxGYT0JO4s+04E4gtKhAi8eZ4OztEvaDEj8n3WEBsEQEPiflv9oDV
	MwucYZL4ul4XxBYWcJf4umEzM8TifYwSk3/9ZAM5jlNAW6JzoiGIyQw0//5FLYhWeYnNa94y
	T2AUmIVkwyyEqllIqhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7nZ1I7GFc2WBxi
	FOBgVOLhvRH/O1iINbGsuDL3EKMEB7OSCC/DQ6AQb0piZVVqUX58UWlOavEhRlOg/ycyS4km
	5wNTTV5JvKGxiZmRpZG5oYWRsbmSOO+BVutAIYH0xJLU7NTUgtQimD4mDk6pBsb6dZ19JUIr
	jhl37TmbGZaReWnGtpqZYq+sf757Y++T+DXghK+8+IU5T2fprVq7Ymo2s9JBldR7cs7iHEKn
	by6fdMZ9EpvR4+nT9t89vi9c4auaV+zHx1f5XnhlebHHBDc+CFLcWzg/Xsi+LKRK9tWV2U4B
	ujfCL7BPuegi7rP6vMNqBfacukVKLMUZiYZazEXFiQB3D4jZ/QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 03:35 PM, Andrzej Hajda wrote:
> On 08/26/2014 07:57 AM, Joonyoung Shim wrote:
>> Hi Andrzej,
>>
>> On 08/22/2014 04:52 PM, Andrzej Hajda wrote:
>>> FIMC in default mode of operation uses only one input buffer,
>>> but the driver used also second buffer, as a result only the
>>> first frame was processed correctly. The patch fixes it.
>> I can't understand well, then we don't need to distinguish buf_id in
>> fimc_src_set_addr()?
> Yes. FIMC in default operation mode uses only one input buffer pointer
> which should
> be updated when processing of the previous buffer has been finished.
> 
> There exists also ping-pong mode which uses two buffer pointers, as I
> have spotted in
> specs. However I have not seen it was implemented neither in drm,
> neither in camera drivers.
> I will try to implement it later.

OK if operation is no problem, and i think it's better to add comments
about this.

> 
> Regards
> Andrzej
> 
>>
>>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>>> ---
>>>  drivers/gpu/drm/exynos/exynos_drm_fimc.c | 16 ++++++++--------
>>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
>>> index b20078e..e985253 100644
>>> --- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
>>> @@ -720,24 +720,24 @@ static int fimc_src_set_addr(struct device *dev,
>>>  	case IPP_BUF_ENQUEUE:
>>>  		config = &property->config[EXYNOS_DRM_OPS_SRC];
>>>  		fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_Y],
>>> -			EXYNOS_CIIYSA(buf_id));
>>> +			EXYNOS_CIIYSA0);
>>>  
>>>  		if (config->fmt == DRM_FORMAT_YVU420) {
>>>  			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CR],
>>> -				EXYNOS_CIICBSA(buf_id));
>>> +				EXYNOS_CIICBSA0);
>>>  			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CB],
>>> -				EXYNOS_CIICRSA(buf_id));
>>> +				EXYNOS_CIICRSA0);
>>>  		} else {
>>>  			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CB],
>>> -				EXYNOS_CIICBSA(buf_id));
>>> +				EXYNOS_CIICBSA0);
>>>  			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CR],
>>> -				EXYNOS_CIICRSA(buf_id));
>>> +				EXYNOS_CIICRSA0);
>>>  		}
>>>  		break;
>>>  	case IPP_BUF_DEQUEUE:
>>> -		fimc_write(ctx, 0x0, EXYNOS_CIIYSA(buf_id));
>>> -		fimc_write(ctx, 0x0, EXYNOS_CIICBSA(buf_id));
>>> -		fimc_write(ctx, 0x0, EXYNOS_CIICRSA(buf_id));
>>> +		fimc_write(ctx, 0x0, EXYNOS_CIIYSA0);
>>> +		fimc_write(ctx, 0x0, EXYNOS_CIICBSA0);
>>> +		fimc_write(ctx, 0x0, EXYNOS_CIICRSA0);
>>>  		break;
>>>  	default:
>>>  		/* bypass */
>>>
>>
> 
> 

