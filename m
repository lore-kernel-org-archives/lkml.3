Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab3ANWIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:08:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:15290 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab3ANWIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:08:49 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d7-50f481ef19bc
Message-id: <50F481F5.9070804@samsung.com>
Date: Tue, 15 Jan 2013 07:08:53 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/11] extcon-arizona updates
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <50EF71C3.6060009@samsung.com>
 <20130114075923.GD4833@opensource.wolfsonmicro.com>
 <20130114142921.GB20384@kroah.com>
In-reply-to: <20130114142921.GB20384@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t8zTd33jV8CDDa9MrO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZjYdSCzazVcz5eImxgbGftYuRk0NCwETi4r7L7BC2mMSFe+vZ
	uhi5OIQEljFKdP19zgZT1L3vBlRiEaPE50vzWSGcLiaJ5x+2MIFU8QpoSUzsOA82ikVAVeLp
	y2lgcTag+P4XIN0cHKICERK/+jkgygUlfky+xwJiiwgYS/SfncUOMpNZ4BSjxJYZx8F6hQUM
	JA6sOwtmCwnsYZR4e8YKxOYU0JdYs24Z2C5mAR2J/a3T2CBseYnNa94yQ9wgIPFt8iEWkL0S
	ArISmw4wg8yXEGhml/jcfATqZUmJgytusExgFJuF5KZZSMbOQjJ2ASPzKkbR1ILkguKk9Fwj
	veLE3OLSvHS95PzcTYyQmJDewbiqweIQowAHoxIP703dLwFCrIllxZW5hxglOJiVRHh3RgKF
	eFMSK6tSi/Lji0pzUosPMfoAXTuRWUo0OR8Yr3kl8YbGBsaGhpaGZqaWpgY4hJXEeRlPPQkQ
	EkhPLEnNTk0tSC2CGcfEwSnVwBj2dOJm5pDWdZzKjovOLAp5ueJC17P1t358vcY+ySXLsk57
	wtRgrsTTH1N75HTrohL279TLmHg8WuGIaPjjba84XlfcM2aw2NzStEJtSbbRwqjqfUHKm5Y9
	2nvtTWGfMb9Yj6SNUPXujE+eavZTjoT8lfRS2j2V56SoufDN/wk3k5r0uV03L1NiKc5INNRi
	LipOBADUxYuGtgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd33jV8CDGb3G1hc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjMZDqQWb2SrmfLzE2MDY
	z9rFyMkhIWAi0b3vBhuELSZx4d56IJuLQ0hgEaPE50vzWSGcLiaJ5x+2MIFU8QpoSUzsOM8O
	YrMIqEo8fTkNLM4GFN//AmQSB4eoQITEr34OiHJBiR+T77GA2CICxhL9Z2exg8xkFjjFKLFl
	xnGwXmEBA4kD686C2UICexgl3p6xArE5BfQl1qxbBraLWUBHYn/rNDYIW15i85q3zBMYBWYh
	2TELSdksJGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH3DPpHYyrGiwOMQpwMCrx
	8N7U/RIgxJpYVlyZe4hRgoNZSYR3ZyRQiDclsbIqtSg/vqg0J7X4EKMPMAQmMkuJJucDk0Fe
	SbyhsYmZkaWRmbGJubExDmElcV7GU08ChATSE0tSs1NTC1KLYMYxcXBKNTAGbVebNW1D0pSS
	yKKoxOeNvWzCJkY7i5oKt7Vaxt/4keLXUiPPIdr0XnvXDMs8gdzZ97dN5mGfdEN+r9SrKeGz
	J59ZyVO9jjX/im3Z+x3TD8rOYGXX77RbyV0dfpJxu/6BKnO5AJPjBteuMYqZLS4UvzJd1YCp
	TPdjzar1SyYduZDS1ie34JoSS3FGoqEWc1FxIgDBG6DT5QIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 11:29 PM, Greg Kroah-Hartman wrote:
> On Mon, Jan 14, 2013 at 04:59:25PM +0900, Mark Brown wrote:
>> On Fri, Jan 11, 2013 at 10:58:27AM +0900, Chanwoo Choi wrote:
>>
>>> Applied this patch set.
>>
>>> You can check this on extcon git repository:
>>> http://git.kernel.org/?p=linux/kernel/git/chanwoo/extcon.git;a=shortlog;h=refs/heads/for-next
>>
>> Looks good.  It does seem this tree isn't in -next, though - if this
>> tree ends up getting sent to Linus (via Greg I guess?) it'd make sense
>> to do that so we get integration testing for it as soon as possible.
> 
> It would be good if Chanwoo sent me pull requests, I thought that was
> going to happen but I have not seen any yet...
> 

OK, I will send pull request to GregKH for extcon immediately.

Best Regards,
Chanwoo Choi
