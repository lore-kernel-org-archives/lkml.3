Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3EFHLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:11:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20525 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3EFHL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:11:28 -0400
X-AuditID: cbfee68d-b7f016d000007930-80-5187579ff0e5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mika Westerberg'" <mika.westerberg@linux.intel.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <002e01ce4a0e$cbe76460$63b62d20$@samsung.com>
 <20130506070429.GA29823@intel.com>
In-reply-to: <20130506070429.GA29823@intel.com>
Subject: Re: [PATCH 1/8] mfd: intel_msic: remove unnecessary
 platform_set_drvdata()
Date: Mon, 06 May 2013 16:11:26 +0900
Message-id: <007a01ce4a28$eca5f710$c5f1e530$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQE/ufIqnvnY4GLKUloJ71Imd8cSKAFF0sl8mgqvA4A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zY9354e2BBmc7BS0uL7zEanF51xw2
	iynbj7BbnO5mdWDxmHcy0KNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgy9izsYinoY63Yfm0C
	WwNjP0sXIweHhICJxImjVl2MnECmmMSFe+vZuhi5OIQEljFKHDu+mQmm5sVSNYj4dEaJ65Ov
	MUE4vxglpj59xgbSzSagJvHly2F2EFtEwFxi0vYZLCA2s0COxIvmPcwgtpBAnMT1vumsIEM5
	BfQlVp9yBAkLC4RKPLrZAtbKIqAqsfDoMkYQm1fAUmLvwgssELagxI/J96BGakms33mcCcKW
	l9i85i0zxAMKEjvOvmaEOMFKYsvU3ewQNSIS+168Y4SoOcYu8WxVIMQuAYlvkw9Bw0FWYtMB
	qDGSEgdX3GCZwCgxC8nmWUg2z0KyeRaSDQsYWVYxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525i
	hMRg7w7G2wesDzEmA62fyCwlmpwPjOG8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTA2cQkF/9F9IKe1kPvN8u/zhF/cur7mlstcVq8Hog7nXhQr
	qYm5vp8QE5ErVbzLK/12xy3LoussLOJPOuQ0P3R2bti4XOTIMoPp+g3b75o2c0nqy7yJTF6l
	WKdwzaKl8dap49tPi1nVxvNEKvIdmiA8p9xITGSemflmZ6bdrV/KKtb8OVHNqazEUpyRaKjF
	XFScCABfzPzv1wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jQd354e2BBi/W8FpcXniJ1eLyrjls
	FlO2H2G3ON3N6sDiMe9koEffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8eb
	mhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYALVNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsS
	BNdjZIAGEtYxZuxZ2MVS0Mdasf3aBLYGxn6WLkYODgkBE4kXS9W6GDmBTDGJC/fWs3UxcnEI
	CUxnlLg++RoThPOLUWLq02dsIFVsAmoSX74cZgexRQTMJSZtn8ECYjML5Ei8aN7DDGILCcRJ
	XO+bzgqygFNAX2L1KUeQsLBAqMSjmy1grSwCqhILjy5jBLF5BSwl9i68wAJhC0r8mHwPaqSW
	xPqdx5kgbHmJzWveMkMcqiCx4+xrRogTrCS2TN3NDlEjIrHvxTvGCYxCs5CMmoVk1Cwko2Yh
	aVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjKn0ntYFzZYHGIUYCDUYmHt+BJW6AQ
	a2JZcWXuIUYJDmYlEV6fvUAh3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgcmoLySeENjEzMj
	SyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYDRYp/fcyu9IXObXAh/hF5Om
	8b5JMVo0l9Hg6OFbZ1wffOB6tEH098un7Bm/E5erx/JavbqgPuvm/pkri/7Oy5XY4tr5sOyz
	QGLnzW9urCsCu9/vzXTf4XHWqd5xTe6W8ukWjNYXDqjMlOwQvsF8U6K25FNmwEP1k+tXXD/d
	tIc/9Af/wbZ30peVWIozEg21mIuKEwF1/ReqNgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 06, 2013 4:04 PM, Mika Westerberg wrote:
> On Mon, May 06, 2013 at 01:04:25PM +0900, Jingoo Han wrote:
> > The driver core clears the driver data to NULL after device_release
> > or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> > (device-core: Ensure drvdata = NULL when no driver is bound).
> > Thus, it is not needed to manually clear the device driver data to NULL.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Hi Mika Westerberg,

Thank you for your Acked-by. :)
It is very helpuful.

Best regards,
Jingoo Han

