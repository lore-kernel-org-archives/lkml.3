Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab3ANWlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:41:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17142 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab3ANWlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:41:16 -0500
X-AuditID: cbfee61b-b7f616d00000319b-c8-50f4898bbbde
Message-id: <50F48991.1040800@samsung.com>
Date: Tue, 15 Jan 2013 07:41:21 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        cwchoi00@gmail.com
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t8zPd3uzi8BBpMW8Flc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M/pbdjAUb2CpOrj/M2sDYw9rFyMkhIWAiMX/yISYIW0ziwr31
	bF2MXBxCAssYJSa93cQCU3Sq9z4jiC0kMJ1RYsZGZoiiLiaJTa+Wg3XzCmhJ3Llylx3EZhFQ
	lVh44BlYMxtQfP+LG0BTOThEBSIkfvVzQJQLSvyYfA+sRETAWKL/7Cx2kJnMAg8YJR63/wRL
	CAsYSBxYd5YJYvEeRom3Z6xAbE4BfYk165aB7WIW0JHY3zqNDcKWl9i85i0zxA0CEt8mH2IB
	2SshICux6QDYzRIC7ewSG1/uhfpeUuLgihssExjFZiG5aRaSsbOQjF3AyLyKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIyQmpHcwrmqwOMQowMGoxMN7U/dLgBBrYllxZe4hRgkOZiUR3p2R
	QCHelMTKqtSi/Pii0pzU4kOMPkDXTmSWEk3OB8ZrXkm8obGBsaGhpaGZqaWpAQ5hJXFexlNP
	AoQE0hNLUrNTUwtSi2DGMXFwSjUwigfF+ni7rnz3O+P602czf8+xXXZifd+vwq8Gp28r70lQ
	yo17uIt98oW357KqTzcbKPxKNrX+4rCnZlOsVOudK+lbTe+++jG/b6vYlslrn575/OaVPpuW
	woo634Ys9idnD/0LcVMsPPb1Y+KvqJe255Wav/UfkbJ68/Gq45PTRmnV5n1rLFQWOyuxFGck
	GmoxFxUnAgD5oJQqtgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jQd3uzi8BBjeWsVlc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjP6W3YwFG9gqTq4/zNrA
	2MPaxcjJISFgInGq9z4jhC0mceHeejYQW0hgOqPEjI3MXYxcQHYXk8SmV8uZQBK8AloSd67c
	ZQexWQRUJRYeeMYCYrMBxfe/uAHUzMEhKhAh8aufA6JcUOLH5HtgJSICxhL9Z2exg8xkFnjA
	KPG4/SdYQljAQOLAurNMEIv3MEq8PWMFYnMK6EusWbcMbBezgI7E/tZpbBC2vMTmNW+ZJzAK
	zEKyYxaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI64Z9I7GFc1WBxiFOBg
	VOLhvan7JUCINbGsuDL3EKMEB7OSCO/OSKAQb0piZVVqUX58UWlOavEhRh9gCExklhJNzgcm
	g7ySeENjEzMjSyMzYxNzY2McwkrivIynngQICaQnlqRmp6YWpBbBjGPi4JRqYIyP/bnly/2V
	Mg6v1pvmKgfZndr6f92bK4k+Nj57np/LZnQyeM15l/W5wFXmsgdVDIfWWc1gvuscrF1xuuf0
	5p+dx5pyNjx5yD9HUOPXlrkVLRbyEk//nrrEKOIxL91n03Jto6izH/5f8Tw931Q+daWyT+ql
	TysfemlM5Uz8myPiV7nQ2DSr86sSS3FGoqEWc1FxIgBssQQ05QIAAA==
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

Thank you,
Chanwoo Choi
