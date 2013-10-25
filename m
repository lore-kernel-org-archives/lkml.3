Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab3JYJIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:08:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47394 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3JYJIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:08:32 -0400
X-AuditID: cbfee68f-b7f836d000001b39-48-526a350e120f
Message-id: <526A3510.1020603@samsung.com>
Date: Fri, 25 Oct 2013 18:08:32 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] regulator: s5m8767: Modify parse_dt function to parse
 data related to ramp
References: <1381369296-17101-1-git-send-email-cw00.choi@samsung.com>
 <20131024101501.GA17157@sirena.org.uk>
In-reply-to: <20131024101501.GA17157@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWyRsSkRJfPNCvI4PgVGYupD5+wWcw/co7V
	4mzTG3aLb1c6mCwu75rDZnFxxRcmBzaPnbPusntsWtXJ5tG3ZRWjx+dNcgEsUVw2Kak5mWWp
	Rfp2CVwZC062sBV8ZKpYNnE6YwPjMqYuRk4OCQETiVsP5rFB2GISF+6tB7K5OIQEljJKTP13
	hrmLkQOsaPEuRYj4dEaJY8+msEI4rxglPk9bxghSxCugJTFjTQ3IIBYBVYntL/aDLWADCu9/
	cQNsgahAmMTK6VdYQGxeAUGJH5PvgdkiAsoSV7/vZQGZySwwmVHi0qXpzCAJYYFUiQvHD4MN
	EhLIk/h1ahs7iM0pYCxxfNdSsGZmAR2J/a3T2CBseYnNa94ygwySEDjFLtG/8jMzxEUCEt8m
	H2KB+EZWYtMBZoiPJSUOrrjBMoFRbBaSm2YhGTsLydgFjMyrGEVTC5ILipPSi4z1ihNzi0vz
	0vWS83M3MQJj7PS/Z/07GO8esD7EmAy0ciKzlGhyPjBG80riDY3NjCxMTUyNjcwtzUgTVhLn
	vf8wKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo1/EnV4bxdLSg7ErvhZovIk33eO65rTp
	jfPdxa1LGkLlj6mHHTuXKTFx4p0D+n8S2JUD5Xj1yv2dbF+ZBHqwsk/Ur3Z9cujOO+V92VYX
	mB+c+LwyhOvBJ+sEsxLmzEsutvpVSd953p7wzheUdzYw+t4Z9qD7fem/3T4veJ5M/+j00MhI
	kW+GEktxRqKhFnNRcSIAL6vZ2McCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQV0+06wggxX3RS2mPnzCZjH/yDlW
	i7NNb9gtvl3pYLK4vGsOm8XFFV+YHNg8ds66y+6xaVUnm0ffllWMHp83yQWwRDUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZiw42cJW8JGpYtnE6YwNjMuYuhg5OCQETCQW
	71LsYuQEMsUkLtxbz9bFyMUhJDCdUeLYsymsEM4rRonP05YxgjTwCmhJzFhTA9LAIqAqsf3F
	fiYQmw0ovP/FDTYQW1QgTGLl9CssIDavgKDEj8n3wGwRAWWJq9/3soDMZBaYzChx6dJ0ZpCE
	sECqxIXjh8EGCQnkSfw6tY0dxOYUMJY4vmspWDOzgI7E/tZpbBC2vMTmNW+ZJzAKzEKyYxaS
	sllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7gZ9I7GFc1WBxiFOBgVOLhTZiR
	GSTEmlhWXJl7iFGCg1lJhFfFKCtIiDclsbIqtSg/vqg0J7X4EGMyMAgmMkuJJucDk0teSbyh
	sYmZkaWRuaGFkbE5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTCyXOGU3K/0bM/6xKSY
	l0vOGe1v+W9z6WmA7YEcxzmi2ow/H1puFRKeytJ0eZrlSwHdl7ZXZsruu6Vxd+92rv7F0YUr
	LZ4w+r78uWJd5tUppUxuOmdv965T4v9+aMfl2/HxGwvjdhpVmd97/Oz+wrYrH3UWr815yuN1
	wH1G9IoZ067s8/A/3eMeosRSnJFoqMVcVJwIAOJzQcMkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 07:15 PM, Mark Brown wrote:
> On Thu, Oct 10, 2013 at 10:41:35AM +0900, Chanwoo Choi wrote:
>> This patch parse 'buck[2-4]_ramp_enable and buck_ramp_delay' platform data
>> from dts file.
> 
> Applied both, thanks.  Please submit a followup patch to use
> of_property_read_bool() as noted by Mark.
> 

OK, Thanks,

Best regards,
Chanwoo Choi
