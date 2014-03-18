Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaCRMEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:04:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35964 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbaCRMEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:04:44 -0400
X-AuditID: cbfee68e-b7f566d000002344-e8-5328365bc32e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, balbi@ti.com, myungjoo.ham@samsung.com
Cc: kishon@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/2] extcon: of: Update OF helper function
Date: Tue, 18 Mar 2014 21:04:38 +0900
Message-id: <1395144280-23240-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWyRsSkWDfaTCPYYMIyXouD9+strn95zmrR
	vHg9m8WFpz1sFpd3zWGzmL2kn8Vi0bJWZovbjSvYHDg89s9dw+7Rt2UVo8fxG9uZPD5vkgtg
	ieKySUnNySxLLdK3S+DK2LAxuOAve8XX+XdZGhh3s3UxcnJICJhI3Dr3jB3CFpO4cG89UJyL
	Q0hgKaPE9sbv7DBF7498YoJILGKU+Hv4JytIQkigkUni5BMREJtNQEti/4sbYFNFBNwk9jQc
	ZwZpYBboY5SY+HgNE0hCWMBK4t7P2UDNHBwsAqoS++YogZi8Aq4Sx1abQeySk/iw5xHU3v9s
	Eoemp4DYLAICEt8mH2IBKZcQkJXYdIAZokRS4uCKGywTGAUXMDKsYhRNLUguKE5KLzLSK07M
	LS7NS9dLzs/dxAgM19P/nvXtYLx5wPoQYzLQuInMUqLJ+cBwzyuJNzQ2M7IwNTE1NjK3NCNN
	WEmcd9HDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjLXnTqkskngaYjv7zP77E+YVb14q
	fuii5FyemoV/NRqvrjsU8k1zUgTbyui899k35UV+aN+7EVkgWL9n4YwN6bGqTPFpljkrk77s
	YAt7LSZ7vmbGX64lAfM+Sf4uPfnppQtrVF8R44Sq6Tn5xUETzWeExot1HDU3ZdW09Go/UWSW
	NHGW5OukaUosxRmJhlrMRcWJAAW6ByttAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd1oM41gg6eHWCwO3q+3uP7lOatF
	8+L1bBYXnvawWVzeNYfNYvaSfhaLRctamS1uN65gc+Dw2D93DbtH35ZVjB7Hb2xn8vi8SS6A
	JaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8aGjcEFf9krvs6/y9LAuJut
	i5GTQ0LAROL9kU9MELaYxIV764HiXBxCAosYJf4e/skKkhASaGSSOPlEBMRmE9CS2P/iBliz
	iICbxJ6G48wgDcwCfYwSEx+vAZskLGAlce/nbKBmDg4WAVWJfXOUQExeAVeJY6vNIHbJSXzY
	84h9AiP3AkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB8fBMagfjygaLQ4wCHIxKPLwv
	2NSDhVgTy4orcw8xSnAwK4nw7tfRCBbiTUmsrEotyo8vKs1JLT7EmAy0eyKzlGhyPjBW80ri
	DY1NzIwsjcwNLYyMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB8dyf6dY/dLSerPQu
	zjmwx0b+pgNPZuSag8dm1raa2prL6q2/d74lY82lGQ6RHw8vr9KcMOv3rFeF3Z8DZt6uunrg
	hI9X893EqN2fru9fenvJ/uPXtp1IPvGE44XKd2kHPj5+Yc241X9S+9oC8xW3+Bxh9lz5O2Oe
	wTFH+Yd9DgJh4Xnumm4q95RYijMSDbWYi4oTAeyqE3jLAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thisp patchset remove unnecessary function call in of_extcon_get_extcon_dev()
which get the extcon device from devicetree. Also, this patchset move OF helper func
to extcon core and change function name as following:
- of_extcon_get_extcon_dev() -> extcon_get_edev_by_phandle()

Chanwoo Choi (2):
  extcon: of: Remove unnecessary function call by using the name of device_node
  extcon: Move OF helper function to extcon core and change function name

 drivers/extcon/Kconfig           |  4 ---
 drivers/extcon/Makefile          |  2 --
 drivers/extcon/extcon-class.c    | 43 +++++++++++++++++++++++++++
 drivers/extcon/of_extcon.c       | 64 ----------------------------------------
 drivers/usb/dwc3/dwc3-omap.c     |  3 +-
 include/linux/extcon.h           | 12 ++++++++
 include/linux/extcon/of_extcon.h | 31 -------------------
 7 files changed, 56 insertions(+), 103 deletions(-)
 delete mode 100644 drivers/extcon/of_extcon.c
 delete mode 100644 include/linux/extcon/of_extcon.h

-- 
1.8.0

