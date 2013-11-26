Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3KZHoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:44:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40914 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3KZHoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:44:10 -0500
X-AuditID: cbfee68f-b7f336d00000481b-2d-529451486179
Message-id: <52945148.2020205@samsung.com>
Date: Tue, 26 Nov 2013 16:44:08 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] extcon fixes for 3.13-rc2
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWyRsSkUNcjcEqQwaKrqhbNi9ezWZxtesNu
	senxNVaLy7vmsFncblzB5sDqsX/uGnaPzUvqPfq2rGL0+LxJLoAlissmJTUnsyy1SN8ugStj
	Xtt35oI/nBUT7/9kb2Bcy9HFyMkhIWAiseT9UXYIW0ziwr31bF2MXBxCAksZJdobt7LCFL1s
	2MUMkVjEKHHkzD1WCOcVo8S23/sYQap4BbQkWr+dBGrn4GARUJVoaywACbMBhfe/uMEGYosK
	hEmsnH6FBaJcUOLH5HtgtoiAhsTLo7dYQGYyCxxilLhw/gzYScICuhLHdx4DK2IW0JHY3zqN
	DcKWl9i85i3YRRICi9glruxbDnYqi4CAxLfJh1hAjpAQkJXYdIAZ4gNJiYMrbrBMYBSZhWT3
	LCRjZyEZu4CReRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYKSc/vesfwfj3QPWhxiTgVZO
	ZJYSTc4HRlpeSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamBMujX/rpWWj/uvA0c9DfjnvKivf+MsIHVlSx+PjWBZ/mrlsvoao3v7P/Bt+x2j+6xv
	pp6P1feuGYkM6knuO7f2a/69kBB7NkK8aY2zg93mgsDvVz5uvah8+RWvJf/bmijfM4l3rPRW
	qhjmzlGcsX3D2h1lkS5u57P4zvdWvfzBuXyBtmF5/zQlluKMREMt5qLiRAChsevXqgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAV2PwClBBn2n5S2aF69nszjb9Ibd
	YtPja6wWl3fNYbO43biCzYHVY//cNewem5fUe/RtWcXo8XmTXABLVAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QXiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYQ1jxry278wFfzgrJt7/yd7AuJaji5GTQ0LAROJlwy5mCFtM
	4sK99WxdjFwcQgKLGCWOnLnHCuG8YpTY9nsfI0gVr4CWROu3k0BVHBwsAqoSbY0FIGE2oPD+
	FzfYQGxRgTCJldOvsECUC0r8mHwPzBYR0JB4efQWC8hMZoFDjBIXzp9hB0kIC+hKHN95DKyI
	WUBHYn/rNDYIW15i85q3zBMY+WYhmTULSdksJGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl
	5+duYgTH4TPpHYyrGiwOMQpwMCrx8Ep0Tg4SYk0sK67MBbqGg1lJhNf1PlCINyWxsiq1KD++
	qDQntfgQYzLQpxOZpUST84EpIq8k3tDYxMzI0sjc0MLI2Jw0YSVx3oOt1oFCAumJJanZqakF
	qUUwW5g4OKUaGBtv8f/KPlyyW3BFybqQdc/EXhj8aMmt7Vpw53Qsb1O6m8quFbwasavkLaWD
	Jkw+OpHnlO4Cs9WXOjlf+v47GbExRPxi3dk90TuvxTEILo+Tqnz82DRW9ea/18sfXFhh9KBC
	/uedVrZ72h95PuYHLz9+aQ6LpLGMcuQ1r2XH+SZv3qezavUUezUlluKMREMt5qLiRADgf4UU
	BwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is extcon fixes pull request for 3.13-rc2. I add detailed description of
this pull request on below. Please pull extcon fixes with following updates.

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-linus-for-3.13-rc2

for you to fetch changes up to 7585ca0dc950583be7fc62099ca43a0c9551a875:

  extcon: remove freed groups caused the panic or warning in unregister flow (2013-11-26 15:17:23 +0900)

----------------------------------------------------------------
Update extcon for 3.13-rc2

This patchset fix NULL pointer error of extcon-arizona driver and fix issue
about memory of device groups when calling extcon_dev_unregister function.

----------------------------------------------------------------
Charles Keepax (1):
      extcon: arizona: Get pdata from arizona structure not device

Wang, Xiaoming (1):
      extcon: remove freed groups caused the panic or warning in unregister flow

 drivers/extcon/extcon-arizona.c | 4 +---
 drivers/extcon/extcon-class.c   | 3 ++-
 2 files changed, 3 insertions(+), 4 deletions(-)
