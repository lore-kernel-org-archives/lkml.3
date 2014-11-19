Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbaKSIVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:21:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61560 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbaKSIU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:20:59 -0500
X-AuditID: cbfee68f-f791c6d000004834-e9-546c52cd955b
Message-id: <546C52CD.2030209@samsung.com>
Date: Wed, 19 Nov 2014 17:20:29 +0900
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+Zpu7ZoJwQg2PrjS3WTFzIbHG26Q27
	xZxrfcwWl3fNYbN4s+IOu8XWHgkHNo++LasYPWb3PWXyuPJ9NaPH501yASxRXDYpqTmZZalF
	+nYJXBn3Z+5lKfgiV7GlYR9rA+MByS5GTg4JAROJXXNWskHYYhIX7q0Hs4UEljFKHJrGAlPT
	tvA2UxcjF1B8EaPE+kcHoZxXjBJr9rxhAqniFdCSeNb7nhnEZhFQlfi+excjiM0mYCBxpaMH
	zBYVCJPYvmYCM0S9oMSPyfdYQAaJCFxnlPh58zHYOmGQk9ZOZoc4I1mi5+BEsAWcAuYSOw49
	BzuPWcBWYsH7dSwQtrzE5jVvmUEGSQhsYpd4sPIsO8QVAhLfJh8CKuIASshKbDrADPGOpMTB
	FTdYJjCKzkJyxywkY2chGbuAkXkVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkgs9e9gvHvA
	+hCjAAejEg/vi7fZIUKsiWXFlbmHGE2BrpjILCWanA+M2LySeENjMyMLUxNTYyNzSzMlcd6F
	Uj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDOm/lIdnfXh1nLjJQeNrCIr/kbcMCAYU/d
	8uuLJ9ifubdc1yG/96rONJdT/hFvjvLptxxSyv49ZaXgxcC1cX9Cnle2++25fTo3dzPP18dP
	vD5zrUn8J/O+iW9eZyPXlDLDl6tOdmi2GMsJHhUpi33SI2mk9i4tfEE3V+2bJZ4H+67EaM1j
	KlymxFKckWioxVxUnAgA4QEjv6ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t9jAd2zQTkhBnO69C3WTFzIbHG26Q27
	xZxrfcwWl3fNYbN4s+IOu8XWHgkHNo++LasYPWb3PWXyuPJ9NaPH501yASxRDYw2GamJKalF
	Cql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDLlRTKEnNKgUIBicXF
	Svp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZ92fuZSn4IlexpWEfawPjAckuRk4OCQETibaF
	t5kgbDGJC/fWs3UxcnEICSxilFj/6CAThPOKUWLNnjdgVbwCWhLPet8zg9gsAqoS33fvYgSx
	2QQMJK509IDZogJhEtvXTGCGqBeU+DH5HgvIIBGB64wSP28+ZgFJCAOt3rV2MjuILSSQLNFz
	cCLYAk4Bc4kdh56zgdjMArYSC96vY4Gw5SU2r3nLPIGRfxaSubOQlM1CUraAkXkVo2hqQXJB
	cVJ6rqFecWJucWleul5yfu4mRnCsPpPawbiyweIQowAHoxIP74u32SFCrIllxZW5hxglOJiV
	RHhPeueECPGmJFZWpRblxxeV5qQWH2I0BXp7IrOUaHI+MI3klcQbGpuYGVkamRmbmBsbK4nz
	Hmi1DhQSSE8sSc1OTS1ILYLpY+LglGpg5GctMi2zXHnu6bEnW28raLlIKtk+unSgLr+WYc8u
	R2PJ84vmBTwwiguZK/zA9NkRNbu6920LF3vObElY9JSj+lL1t2xW+9hVf0+eXVyX1OGvMFX/
	Nct8Ec9wpiCOhKvKe3a71+SKOp808J99u+i22Z2z12ds0GB5tm/O3bQ5eQ7vJjwO1+YIV2Ip
	zkg01GIuKk4EAFEJ5MvrAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

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

