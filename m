Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762Ab3DHCCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 22:02:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16497 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934704Ab3DHCCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 22:02:12 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-08-5162252289cf
Message-id: <51622526.8000302@samsung.com>
Date: Mon, 08 Apr 2013 11:02:14 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>
Subject: [GIT PULL] extcon fixes for 3.9-rc6
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t8zHV0l1aRAg4WvTCyuf3nOatG8eD2b
	xdmmN+wWl3fNYbO43biCzYHVY//cNewefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfH75l6W
	gmNcFZPXPmRvYLzF0cXIySEhYCJx8PwPNghbTOLCvfVANheHkMAyRonTf1cwwRT1/7jGDJGY
	ziixbMUSqKoXjBLf/v8Eq+IV0JL41feJsYuRg4NFQFVi4hlmkDAbUHj/ixtgG0QFwiRWTr/C
	AlEuKPFj8j0wW0RAQ+Ll0VtgNrPAKkaJpydkQGxhAR2JE00z2CDi6hKT5i1ihrDlJTavecsM
	cdxkdol5MwpAbBYBAYlvkw+xgJwgISArsekAVImkxMEVN1gmMIrMQrJ5FpKps5BMXcDIvIpR
	NLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJDr6dzDePWB9iDEZaOVEZinR5HxgdOWVxBsamxlZ
	mJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdHiQV/p/Nl5vhtZ
	83gfrrbr3dQ1k3lqw1SZr3FiyQzWfcJ/j8TPvmr+QTsqnd9KYFv20QZjleNOa2bFsEkUP116
	kbdsqtmXTzuuHJg1aTFTrrTDvYTj0ftmcHz4qPrk1NLm7VOW/q/dY6Xe2pdd8+/z2ynLjH3P
	lAYHhP5vC/duebJDreVk6RMlluKMREMt5qLiRAAfDyOypAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jQV0l1aRAg9cHDCyuf3nOatG8eD2b
	xdmmN+wWl3fNYbO43biCzYHVY//cNewefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RTSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYx5jx++ZeloJjXBWT1z5kb2C8xdHFyMkhIWAi0f/jGjOELSZx4d56
	ti5GLg4hgemMEstWLIFyXjBKfPv/kwmkildAS+JX3yfGLkYODhYBVYmJZ8Ca2YDC+1/cYAOx
	RQXCJFZOv8ICUS4o8WPyPTBbREBD4uXRW2A2s8AqRomnJ2RAbGEBHYkTTTPYIOLqEpPmLWKG
	sOUlNq95yzyBkW8WklGzkJTNQlK2gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw9D2T
	3sG4qsHiEKMAB6MSD++Br4mBQqyJZcWVuYcYJTiYlUR4A5WTAoV4UxIrq1KL8uOLSnNSiw8x
	JgM9OpFZSjQ5H5gY8kriDY1NzIwsjcyMTcyNjUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmD
	U6qBUWuueXHvrGWONxlnrSxpPCxlqmGud0NVkk+rf6/mzaIfOczZsulHlztEP1wQJr9Jj8lR
	iqFXosyJN1VguWjUxhX6zx5xHz+p8HfFloMh7h2n6mdumxcnxhqytr5LM8B6tYfK1aKbLgXM
	bCJTTTPnBxxSelJb06ulmnljz2bZveymBzlXPw9SYinOSDTUYi4qTgQAhP+EUQIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is extcon fixes for 3.9-rc6
Please pull extcon with following updates.

Best Regards and thanks,
Chanwoo Choi

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-3.9-rc6

for you to fetch changes up to 2fbeb4347e02078828510e5fe43ab4bea21b20d1:

  extcon: max8997: Fix return value (2013-04-08 09:13:18 +0900)

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
