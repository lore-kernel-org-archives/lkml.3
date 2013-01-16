Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab3APHpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:45:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59629 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758185Ab3APHp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:45:27 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-41-50f65a964555
Message-id: <50F65AA6.3020208@samsung.com>
Date: Wed, 16 Jan 2013 16:45:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, cwchoi00@gmail.com
Subject: Re: [GIT PULL] extcon for v3.9
References: <50F6437D.50907@samsung.com> <20130116072840.GA1089@kroah.com>
In-reply-to: <20130116072840.GA1089@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t8zTd1pUd8CDF7sFrS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZjYfPMxZM5Kn4seE/cwPjO84uRk4OCQETiekbz7BC2GISF+6t
	Z+ti5OIQEljGKHH+WycjTNGGQy3sILaQwCJGieevayCKupgkPsy4xgSS4BXQknjwaSkziM0i
	oCrx6MxBsGY2oPj+FzeApnJwiApESPzq54AoF5T4MfkeC4gtIqAh8fLoLRaQmcwC7xkl7l2a
	AJYQFlCXuP5iIyPEYi+JLbfWgNmcAnoSa242gO1iFtCR2N86jQ3ClpfYvOYt1A0CEt8mH2IB
	2SshICux6QAzyHwJgXZ2iU0nW5kgHpOUOLjiBssERrFZSG6ahWTsLCRjFzAyr2IUTS1ILihO
	Ss811CtOzC0uzUvXS87P3cQIiQmpHYwrGywOMQpwMCrx8HoVfg0QYk0sK67MPcQowcGsJMK7
	zP5bgBBvSmJlVWpRfnxRaU5q8SFGH6BrJzJLiSbnA+M1ryTe0NjA2NDQ0tDM1NLUAIewkjgv
	46knAUIC6YklqdmpqQWpRTDjmDg4pRoYNfW+rdu8qGf+6sIvFZ/ifBmeL+H5a2oUdyLzqobN
	mVPTd/BpqsZUhPkueGVVlWvuIfJoulPZt/mMfvx9v0r3NHJuVGZpuLNR//CGsr2Xp+zYFXtn
	IkuXdk3J/yMMbxmzBEK81N4sFjn6WUhb5JztK5PvV/mt/rk45sQcuB4vWfK6xi1y5ysWJZbi
	jERDLeai4kQAePRPr7YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd1pUd8CDLb/Z7G4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGY2HzzMWTOSp+LHhP3MD
	4zvOLkZODgkBE4kNh1rYIWwxiQv31rOB2EICixglnr+u6WLkArK7mCQ+zLjGBJLgFdCSePBp
	KTOIzSKgKvHozEFGEJsNKL7/xQ2gZg4OUYEIiV/9HBDlghI/Jt9jAbFFBDQkXh69xQIyk1ng
	PaPEvUsTwBLCAuoS119sZIRY7CWx5dYaMJtTQE9izc0GsF3MAjoS+1unsUHY8hKb17xlnsAo
	MAvJjllIymYhKVvAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjinkntYFzZYHGIUYCD
	UYmH16vwa4AQa2JZcWXuIUYJDmYlEd5l9t8ChHhTEiurUovy44tKc1KLDzH6AENgIrOUaHI+
	MBnklcQbGpuYGVkamRmbmBsb4xBWEudlPPUkQEggPbEkNTs1tSC1CGYcEwenVAOj46dLVU92
	3J8vtfrCWo0d+zXOlp34cnhD2W7muRH2N0uO9a87vG319P0xE09knldVV2RSf2VxqZvboGJl
	YwDn4dUCadefTrw8MWOf+Kxm26lz5LdpbNxa/OVuoPkjN87P1hmrDr+eovfq4TrFBnuJtYkm
	pdr3uqvOvL6tzJZjErWit/rYKztuXSWW4oxEQy3mouJEACjhbKrlAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 04:28 PM, Greg KH wrote:
> On Wed, Jan 16, 2013 at 03:06:53PM +0900, Chanwoo Choi wrote:
>> Hi Greg,
>>
>> This is the extcon pull request for v3.9.
>>
>> I don't send separate pull request of extcon about bugfixes patch.
>> I'd like to apply this patch-set to your next branch for v3.9.
>>
>> Please pull extcon with following updates.
>>
>> Update to max77693/max8997 extcon driver:
>> - Using MHL_TA cable for charging.
>> - Support JIG cable.
>> - Support Dock-Audio device for playing music and button of device.
>> - Support Dock-Smart device for desktop mode with mouse/keyboard.
>> - Set default UART/USB path on probe().
>> - Check the state/type of cable after completing initialization.
>> - Code clean to remove duplicate code and bug fix related to sequence of interrupt.
>> - Fix irq_flag of max8997/max77693 driver.
>>
>> Update to arizona extcon driver:
>> - Headphone measurements.
>> - Alternative detection mechanism for non-default system designs.
>> - Microphone clamp integration.
>> - Support for additional detection pin.
>> - MICBIAS rise time configuration.
>>
>> Best regards,
>> Chanwoo Choi
>>
>> The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:
>>
>>   Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-for-3.9
> 
> Pulled and pushed out, thanks.
> 
Thank you for pulling and comment.

Best Regards,
Chanwoo Choi
