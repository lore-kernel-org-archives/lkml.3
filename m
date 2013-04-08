Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936401Ab3DHXRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:17:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56854 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935512Ab3DHXRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:17:51 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-1b-5163501d4da7
Message-id: <51635022.7000204@samsung.com>
Date: Tue, 09 Apr 2013 08:17:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [GIT PULL] extcon for 3.10
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkWFc2IDnQ4MpnXYvrX56zWjQvXs9m
	cbbpDbvF5V1z2CxuN65gc2D12D93DbtH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZTTMOMta
	sJir4tb5bpYGxgMcXYycHBICJhLzm/YyQ9hiEhfurWfrYuTiEBJYyijx9csLRpii5StWQSWm
	M0pMbGxgh3BeMEqc7bvOClLFK6AlsfnaTSYQm0VAVaLtfS8biM0GFN//4gaYLSoQJrFy+hUW
	iHpBiR+T74HZIgIaEi+P3gKzmQXmMErs/ge2WVhAWeLBiU1sEHEdif2t06BseYnNa94ygxwh
	IdDPLnF11gF2iMUCEt8mHwIaxAGUkJXYdADqNUmJgytusExgFJmFZPUsJGNnIRm7gJF5FaNo
	akFyQXFSepGpXnFibnFpXrpecn7uJkZghJz+92ziDsb7B6wPMSYDrZzILCWanA+MsLySeENj
	MyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MLZpMcbtC4tN
	l9Bf5hJ46f8jvtcCrAdUWX/lh3fc91i3TPlHt9uGQ6aNtw+lrEg3DZk7r7h1QdzbH0/X18mX
	z5opWbi1WCfe0r352RtWE961kp9qGvbYXKx5yXNoYcsEF8WGiENCvqc+Pryc9ryoPTXu1I0v
	uzYqrdzgls/uvfr8fs753N4MAUosxRmJhlrMRcWJANeJi+KmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jQV3ZgORAg86l6hbXvzxntWhevJ7N
	4mzTG3aLy7vmsFncblzB5sDqsX/uGnaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3
	VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqppFCWmFMKFApILC5W0rfDNCE0xE3X
	AqYxQtc3JAiux8gADSSsYcxomHGWtWAxV8Wt890sDYwHOLoYOTkkBEwklq9YxQZhi0lcuLce
	yObiEBKYzigxsbGBHcJ5wShxtu86K0gVr4CWxOZrN5lAbBYBVYm2971g3WxA8f0vboDZogJh
	EiunX2GBqBeU+DH5HpgtIqAh8fLoLTCbWWAOo8Tuf4wgtrCAssSDE5vYIOI6Evtbp0HZ8hKb
	17xlnsDINwvJqFlIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzj+nknvYFzV
	YHGIUYCDUYmH98KTpEAh1sSy4srcQ4wSHMxKIrzdhsmBQrwpiZVVqUX58UWlOanFhxiTgT6d
	yCwlmpwPTA15JfGGxiZmRpZG5oYWRsbmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cBY
	Lznn4gIPoegcI+a+d3tiWbQzFRca+FxqXDiJJTq4wVq4uElx3rtzgVN7mQ497rk8fb8G46P7
	2X7ZVqWvLzTp3lo681vOxc+nSq+c83ppzmXyKPpwi7nzQuNGY17NstWhu25Nu7lDlzXN+er+
	c/d95iyyl7yj2JOb+2UiX8VCG45J/yM23VimxFKckWioxVxUnAgA15g8HwMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is extcon pull request for v3.10.
Please pull extcon with following updates.

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-for-3.10

for you to fetch changes up to 3ad9e86d54ed2770aa693a90a0872cbe7ffc6831:

  extcon: max8997: Fix return value (2013-04-09 07:53:46 +0900)

----------------------------------------------------------------
This is small fixes for extcon driver.

MAX77693 extcon driver
- Add 'static' keryword to internal data structure
- Fix return value using 'ret' instead of hardcoding

MAX8997 extcon driver
- Use dev_err() instead of pr_err()
- Fix return value using 'ret' instead of hardcoding

----------------------------------------------------------------
Jingoo Han (1):
      extcon: max8997: use dev_err() instead of pr_err()

Sachin Kamat (3):
      extcon: max77693: Staticize default_init_data
      extcon: max77693: Fix return value
      extcon: max8997: Fix return value

 drivers/extcon/extcon-max77693.c | 10 +++++-----
 drivers/extcon/extcon-max8997.c  | 12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)
