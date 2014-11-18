Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaKRKxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:53:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:46123 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaKRKw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:52:58 -0500
X-AuditID: cbfee68d-f79296d000004278-50-546b2508056a
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <546B2508.8070409@samsung.com>
Date: Tue, 18 Nov 2014 19:52:56 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] blocked task after exynos_drm_init
References: <1415264811.27478.4.camel@AMDC1943> <546B228E.6030500@samsung.com>
In-reply-to: <546B228E.6030500@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkUJdDNTvE4PIUPotb686xWlz5+p7N
	YtPja6wWl3fNYbOYcX4fkwOrx/3u40wem5fUe/RtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
	9D+fWAqOyFWs2naLrYGxXaqLkYNDQsBE4lyHTxcjJ5ApJnHh3nq2LkYuDiGBpYwSq+43MUEk
	TCSet1xkhEhMZ5SYOPcuWIJXQFDix+R7LCA2s4C6xKR5i5ghbBGJBwtbWCFsbYllC18zQzS/
	YpRY8fcmO0SzlsTVlZ1sIDaLgKrE6sf3wWw2IHviCghbVCBM4sWrXWBDRYAWzD55B2pBD6PE
	4T0mILawgKnEhUUrGUFsIQE/iYMHL4D1cgItvtUzB+wdCYFN7BL/Tm5ggVgmIPFt8iEWiPdl
	JTYdYIb4UlLi4IobLBMYxWch+W0Wkt9mIfltFpLfFjCyrGIUTS1ILihOSi8y1CtOzC0uzUvX
	S87P3cQIjMPT/5717mC8fcD6EKMAB6MSD2/C1KwQIdbEsuLK3EOMpkAXTWSWEk3OB0Z7Xkm8
	obGZkYWpiamxkbmlmZI4r6LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjHsyeG4UKLLP
	vmAtee5dw9tkn/fyO9hWGHl/s+BoXbpFQE+29b3BTpmF07sS0+Re5ktu760+uf2kot/7n+9/
	duh89LpZoKPX4X5O694DPp1H9boP+UK41vqm/mRb0hXnUd53Pkvo87qXprv33UmsS9rqVdWy
	Sfd8VeTf4A9x3FYyFf5pmfUXlFiKMxINtZiLihMBdYvsMr4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQV0O1ewQg8nb2SxurTvHanHl63s2
	i02Pr7FaXN41h81ixvl9TA6sHve7jzN5bF5S79G3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhDWMGS/eX2cp2CRXsXFzJ1MD41fJLkZODgkBE4nnLRcZIWwx
	iQv31rN1MXJxCAlMZ5SYOPcuE0iCV0BQ4sfkeyxdjBwczALyEkcuZYOEmQXUJSbNW8QMUf+K
	UWLF35vsEPVaEldXdrKB2CwCqhKrH98Hs9mA7IkrIGxRgTCJF692MYPYIkCDZp+8wwwxtIdR
	4vAeExBbWMBU4sKilWDHCQn4SRw8eAGsl1NAW+JWzxy2CYwCs5CcNwvhvFlIzlvAyLyKUTS1
	ILmgOCk910ivODG3uDQvXS85P3cTIzhmn0nvYFzVYHGIUYCDUYmHN3FqVogQa2JZcWXuIUYJ
	DmYlEd5z3UAh3pTEyqrUovz4otKc1OJDjKZAz01klhJNzgemk7ySeENjEzMjSyNzQwsjY3Ml
	cd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYyOSu+jv/DxujSaCs9RlfB+4vgl382Rz6zDf4N5
	VFBorEPtLH2zXDXGhw/ey4oeTLl39fq2vOnfXy12/Cqn4p4vteFTT8nJbj1TWdO2M+v6FGXn
	lPoJ3f1TufH/ZfGbLffD0k8z6Z/ga1d+f+n8Lfk5vJfLUjW1LvMWKyw+xsSy9lhCv1HMASWW
	4oxEQy3mouJEAMZJaQTvAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 11월 18일 19:42, Andrzej Hajda wrote:
> On 11/06/2014 10:06 AM, Krzysztof Kozlowski wrote:
>> Hi,
>>
>> On last next (next-20141104, next-20141105) booting locks after
>> initializing Exynos DRM (Trats2 board):
>>
>> [    2.028283] [drm] Initialized drm 1.1.0 20060810
>> [  240.505795] INFO: task swapper/0:1 blocked for more than 120 seconds.
>> [  240.510825]       Not tainted 3.18.0-rc3-next-20141105 #794
>> [  240.516418] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [  240.524173] swapper/0       D c052534c     0     1      0 0x00000000
>> [  240.530527] [<c052534c>] (__schedule) from [<c0525b34>] (schedule_preempt_disabled+0x14/0x20)
>> [  240.539030] [<c0525b34>] (schedule_preempt_disabled) from [<c0526d44>] (mutex_lock_nested+0x1c4/0x464)
>> [  240.548320] [<c0526d44>] (mutex_lock_nested) from [<c02be908>] (__driver_attach+0x48/0x98)
>> [  240.556562] [<c02be908>] (__driver_attach) from [<c02bcc00>] (bus_for_each_dev+0x54/0x88)
>> [  240.564717] [<c02bcc00>] (bus_for_each_dev) from [<c02bdce0>] (bus_add_driver+0xe4/0x200)
>> [  240.572876] [<c02bdce0>] (bus_add_driver) from [<c02bef94>] (driver_register+0x78/0xf4)
>> [  240.580864] [<c02bef94>] (driver_register) from [<c029e99c>] (exynos_drm_platform_probe+0x34/0x234)
>> [  240.589890] [<c029e99c>] (exynos_drm_platform_probe) from [<c02bfcf0>] (platform_drv_probe+0x48/0xa4)
>> [  240.599090] [<c02bfcf0>] (platform_drv_probe) from [<c02be680>] (driver_probe_device+0x13c/0x37c)
>> [  240.607940] [<c02be680>] (driver_probe_device) from [<c02be954>] (__driver_attach+0x94/0x98)
>> [  240.616360] [<c02be954>] (__driver_attach) from [<c02bcc00>] (bus_for_each_dev+0x54/0x88)
>> [  240.624517] [<c02bcc00>] (bus_for_each_dev) from [<c02bdce0>] (bus_add_driver+0xe4/0x200)
>> [  240.632679] [<c02bdce0>] (bus_add_driver) from [<c02bef94>] (driver_register+0x78/0xf4)
>> [  240.640667] [<c02bef94>] (driver_register) from [<c029e938>] (exynos_drm_init+0x70/0xa0)
>> [  240.648739] [<c029e938>] (exynos_drm_init) from [<c00089b0>] (do_one_initcall+0xac/0x1f0)
>> [  240.656914] [<c00089b0>] (do_one_initcall) from [<c074bd90>] (kernel_init_freeable+0x10c/0x1d8)
>> [  240.665591] [<c074bd90>] (kernel_init_freeable) from [<c051eabc>] (kernel_init+0x8/0xec)
>> [  240.673661] [<c051eabc>] (kernel_init) from [<c000f268>] (ret_from_fork+0x14/0x2c)
>> [  240.681196] 3 locks held by swapper/0/1:
>> [  240.685091]  #0:  (&dev->mutex){......}, at: [<c02be908>] __driver_attach+0x48/0x98
>> [  240.692732]  #1:  (&dev->mutex){......}, at: [<c02be918>] __driver_attach+0x58/0x98
>> [  240.700367]  #2:  (&dev->mutex){......}, at: [<c02be908>] __driver_attach+0x48/0x98
> 
> 
> This is caused by patch moving platform devices to
> /sys/devices/platform[1]. Since this patch registering platform
> drivers/devices in probe of platform device causes deadlocks. I guess
> now all driver registration should be moved to exynos_drm_init and it
> seems better location for it IMHO.

Thanks. It might be a chance that we could separate sub drivers of
Exynos drm into independent modules so that they can be called
independently because if we move them to exynos_drm_init then the
deferred probe wouldn't work correctly.

Thanks,
Inki Dae

> 
> Regards
> Andrzej
> 
> [1]: http://www.spinics.net/lists/devicetree/msg56101.html
> 
> 
> 
>>
>> Full dmesg and config attached.
>>
>> Best regards,
>> Krzysztof
>>
>>
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

