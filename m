Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbaKSISS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:18:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:60949 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaKSISQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:18:16 -0500
X-AuditID: cbfee691-f79b86d000004a5a-15-546c5245b8bb
Message-id: <546C5241.6080903@samsung.com>
Date: Wed, 19 Nov 2014 17:18:09 +0900
From: Chan-yeol Park <chanyeol.park@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-11-07
References: <20141118133459.GB27428@node.dhcp.inet.fi>
 <20141118180919.GA32128@t440s.P-661HNU-F1>
In-reply-to: <20141118180919.GA32128@t440s.P-661HNU-F1>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+Zpq5rUE6IwcWzihZrJi5ktjjb9Ibd
	Ys61PmaLy7vmsFm8WXGH3WJrj4QDm0ffllWMHrP7njJ5XPm+mtHj8ya5AJYoLpuU1JzMstQi
	fbsErow1874zF/yQqzg69TJTA+NhyS5GDg4JAROJj6fDuxg5gUwxiQv31rN1MXJxCAksY5R4
	smoZC0TCROJh80+oxHRGiZUn5kE5rxglZh48wgxSxSugJfGs9RcbiM0ioCrxbMMasG42AQOJ
	Kx09jCC2qECYxPY1E6DqBSV+TL7HAjJIROA6o8TPm4/BGoSB1u1aO5kdxBYSSJboOTiRCcTm
	FDCX2HHoOdgCZgFbiQXv17FA2PISm9e8ZQYZJCGwjl3i+LQbzBBXCEh8m3yIBeJPWYlNB5gh
	3pGUOLjiBssERtFZSO6YhWTsLCRjFzAyr2IUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIiaWJ
	OxjvH7A+xCjAwajEw/vybXaIEGtiWXFl7iFGU6ArJjJLiSbnAyM2ryTe0NjMyMLUxNTYyNzS
	TEmcV0f6Z7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxnNvFC9FCk21j7mrXGe74+xPk4eO
	q6Pi1TmLDGOUlm+dt37b62oBHfe7ob7z34naxix7f2bXhefRbS4usffFL/d7i9+8+yw3SUwt
	9MHDgydUiw8u0nnq5evx9uvP2VNdins1n22p+35BbU/EbNult69uluEK9LxkuH5f6pIHs3e8
	ucow/dOsDduVWIozEg21mIuKEwFpHK4xoAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t9jQV3XoJwQg/4tshZrJi5ktjjb9Ibd
	Ys61PmaLy7vmsFm8WXGH3WJrj4QDm0ffllWMHrP7njJ5XPm+mtHj8ya5AJaoBkabjNTElNQi
	hdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDlSgpliTmlQKGAxOJi
	JX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMNfO+Mxf8kKs4OvUyUwPjYckuRk4OCQETiYfN
	P9kgbDGJC/fWA9lcHEIC0xklVp6YB+W8YpSYefAIM0gVr4CWxLPWX2AdLAKqEs82rGEBsdkE
	DCSudPQwgtiiAmES29dMgKoXlPgx+R4LyCARgeuMEj9vPgZrEAZavWvtZHYQW0ggWaLn4EQm
	EJtTwFxix6HnYAuYBWwlFrxfxwJhy0tsXvOWeQIj/ywkc2chKZuFpGwBI/MqRtHUguSC4qT0
	XCO94sTc4tK8dL3k/NxNjOBYfSa9g3FVg8UhRgEORiUe3hdvs0OEWBPLiitzDzFKcDArifCe
	9M4JEeJNSaysSi3Kjy8qzUktPsRoCvT2RGYp0eR8YBrJK4k3NDYxM7I0MjM2MTc2VhLnPdhq
	HSgkkJ5YkpqdmlqQWgTTx8TBKdXAaPS0p2eC4SGerefcpF/yezreMZ/w8fC15sA4Bt2TrNPe
	Cb17eK773tZ4Pun72SJZIcxfv7adZ/oS0Nf56b4h88bdwos9aq/tztgpc3djk+CVZeV/RSdM
	j1/TvMLeyYbn7OJX61tfyvfYyeV2T3kYXPXWYf+WdxLH1gVvYjDySddmD4jnm3D9iBJLcUai
	oRZzUXEiAGHXXOzrAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All

On 11/19/2014 03:09 AM, Johan Hedberg wrote:
> Hi Kirill,
>
> On Tue, Nov 18, 2014, Kirill A. Shutemov wrote:
>> On Fri, Nov 07, 2014 at 11:27:54AM +0200, Johan Hedberg wrote:
>>> Chan-yeol Park (1):
>>>        Bluetooth: Fix hci_sync missing wakeup interrupt
>> Look like this commit causes problem for me:
>>
>> [    2.018671] ------------[ cut here ]------------
>> [    2.022836] WARNING: CPU: 2 PID: 109 at /home/kas/git/public/linux/kernel/sched/core.c:7323 __might_sleep+0xbd/0xd0()
>> [    2.023166] Freeing unused kernel memory: 944K (ffff880001b14000 - ffff880001c00000)
>> [    2.030362] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff819ab67b>] __hci_req_sync+0x7b/0x2a0
>> [    2.034193] Modules linked in:
>> [    2.036133] CPU: 2 PID: 109 Comm: kworker/u17:0 Not tainted 3.18.0-rc4-next-20141117-07404-g9dad2ab6df8b #66
>> [    2.036383] Freeing unused kernel memory: 1404K (ffff8800020a1000 - ffff880002200000)
>> [    2.038940] Hardware name: LENOVO 3460CC6/3460CC6, BIOS G6ET93WW (2.53 ) 02/04/2013
>> [    2.040233] Workqueue: hci0 hci_power_on
>> [    2.041517]  ffffffff81f51d50 ffff8800d3ecfb28 ffffffff81afc316 0000000000000000
>> [    2.042811]  ffff8800d3ecfb78 ffff8800d3ecfb68 ffffffff810fc11a ffff880000000000
>> [    2.042812]  ffffffff81f52a28 000000000000026d 0000000000000000 ffff8800d3ec9200
>> [    2.042813] Call Trace:
>> [    2.042818]  [<ffffffff81afc316>] dump_stack+0x4c/0x6e
>> [    2.042821]  [<ffffffff810fc11a>] warn_slowpath_common+0x8a/0xc0
>> [    2.042823]  [<ffffffff810fc196>] warn_slowpath_fmt+0x46/0x50
>> [    2.042825]  [<ffffffff819ab67b>] ? __hci_req_sync+0x7b/0x2a0
>> [    2.042827]  [<ffffffff819ab67b>] ? __hci_req_sync+0x7b/0x2a0
>> [    2.042830]  [<ffffffff811295ed>] __might_sleep+0xbd/0xd0
>> [    2.042832]  [<ffffffff81b04b8f>] mutex_lock_nested+0x2f/0x450
>> [    2.042835]  [<ffffffff81b0812b>] ? _raw_spin_unlock+0x2b/0x50
>> [    2.042837]  [<ffffffff81131db0>] ? wake_up_process+0x50/0x50
>> [    2.042840]  [<ffffffff813b9ea1>] __create_file+0x71/0x2c0
>> [    2.042842]  [<ffffffff813ba10f>] debugfs_create_file+0x1f/0x30
>> [    2.042844]  [<ffffffff819ac461>] hci_dev_do_open+0x431/0xa70
>> [    2.042846]  [<ffffffff8111a72c>] ? process_one_work+0x13c/0x810
>> [    2.042847]  [<ffffffff819ad2b1>] hci_power_on+0x31/0x1e0
>> [    2.042849]  [<ffffffff8111a7c8>] process_one_work+0x1d8/0x810
>> [    2.042850]  [<ffffffff8111a72c>] ? process_one_work+0x13c/0x810
>> [    2.042851]  [<ffffffff8111b2db>] worker_thread+0x6b/0x4b0
>> [    2.042852]  [<ffffffff8111b270>] ? init_pwq+0xf0/0xf0
>> [    2.042854]  [<ffffffff81120ef9>] kthread+0x119/0x130
>> [    2.042855]  [<ffffffff8112923d>] ? finish_task_switch+0x4d/0x140
>> [    2.042857]  [<ffffffff81120de0>] ? kthread_create_on_node+0x240/0x240
>> [    2.042859]  [<ffffffff81b08cfc>] ret_from_fork+0x7c/0xb0
>> [    2.042861]  [<ffffffff81120de0>] ? kthread_create_on_node+0x240/0x240
>> [    2.042863] ---[ end trace 3a40e80ec4ca7159 ]---
> At least one obvious bug that the patch in question seems to have is
> that it fails to set the state back to TASK_RUNNING in case
> hci_req_run() fails and we never call schedule_timeout(). This would
> also seem to match the error you're getting.
>
> The attached patch fixes the missing set_current_state() calls - could
> you please check if it fixes the issue for you? Out of curiosity, which
> HW are you reproducing this with and are there any special steps
> involved? Looking at the code it seems that at least some older
> Bluetooth adapters could cause some hci_req_run() calls to return
> ENODATA, however I wasn't able to get the warning with any of my own
> adapters (I have one for pretty much every Bluetooth version).
>
> Johan
I agree I made a bug in the previous commit and I think we need to apply 
Johan's patch.
It is working fine on my machine.

Thanks
Chanyeol


