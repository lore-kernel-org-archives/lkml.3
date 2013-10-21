Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3JULmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 07:42:08 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63174 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3JULmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 07:42:05 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-ec-5265130b6afc
Message-id: <1382355719.8172.0.camel@AMDC1943>
Subject: Re: [PATCH] spi/s3c64xx: Fix doubled clock disable on suspend
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Mon, 21 Oct 2013 13:41:59 +0200
In-reply-to: <5264F709.2000409@samsung.com>
References: <1382348117-6666-1-git-send-email-k.kozlowski@samsung.com>
 <5264F709.2000409@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xK7rcwqlBBiu6zS0mrTvAZDH14RM2
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dk0fjxJrvF4TftrA6cHn9XvWD22LSqk81j85J6
	j74tqxg9Pm+SC2CN4rJJSc3JLEst0rdL4MpoW3WWraCBueLzhHVsDYwHmboYOTkkBEwkHu1r
	Z4ewxSQu3FvP1sXIxSEksJRRYvqrN+wQzmdGifarUxhBqngF9CQmnP7FDGILC7hJ/Pu7CizO
	JmAssXn5EjYQW0RAX2LJqotgk5gFZjNJ3J8yG6yIRUBVYtf+TrDVnALaEse/97OC2EIC6RJt
	q7eCncEsoC4xad4iZoiTlCR2t3dCxeUlNq95ywxxhKDEj8n3WCYwCsxC0jILSdksJGULGJlX
	MYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE/pcdjIuPWR1iFOBgVOLhDXBJCRJiTSwrrsw9
	xCjBwawkwvv5I1CINyWxsiq1KD++qDQntfgQIxMHp1QDY3XFl69pmye7G1+5p1LLv1vggNv3
	K4e/CmnrKm0OMstm2cXS+aGmsvCx9+nZq6TnWkRtv7LPpV2c/QyvRfiPPW/YZ4SoRhcucHs1
	8+AvBc8P3d2zmtqeWwq7TuZPUtghYL7Bf9HjZeE3j2pXa96ound4/3L+T8ofw8KX1K3ub7vu
	xZzJ5LwhW4mlOCPRUIu5qDgRAPDIH3xbAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-21 at 11:42 +0200, Sylwester Nawrocki wrote:
> pm_runtime_{get,put}* must not be called from drivers's system suspend/resume
> callbacks. Please use pm_runtime_suspended() to check device runtime PM status
> in s3c64xx_spi_{suspend,resume} callbacks and handle the clocks appropriately.

Thanks for review, I will send fixed patch.

Best regards,
Krzysztof

