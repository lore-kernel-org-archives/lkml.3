Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320Ab3BMXlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:41:46 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59083 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3BMXlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:41:45 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-16-511c24b7680f
Message-id: <511C24B7.4000802@samsung.com>
Date: Thu, 14 Feb 2013 08:41:43 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: gregkh@linuxfoundation.org
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>, kyungmin.park@samsung.com
Subject: [GIT PULL] extcon for 3.9
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t8zLd3tKjKBBk+mi1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MN6sOMBa8FKzonPaKtYFxC18XIweHhICJxLRd5V2MnECmmMSF
	e+vZuhi5OIQEljFK3NtwghkiYSLxY81CFojEdEaJG53vGCGcTiaJuwevgFXxCmhJTO/fzw5i
	swioSrRsWMAIYrMBxfe/uMEGYosKhEmsnH6FBaJeUOLH5HtgtoiAnMST23/A5jAL1Ercf3qM
	GeQ6YQElialXOSHC1hIrJ21jhLDlJTavecsMcoOEwHM2iVkX5zJD7BWQ+Db5EAvEZ7ISmw5A
	PSApcXDFDZYJjCKzkGyehWTsLCRjFzAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQICXCp
	HYwrGywOMQpwMCrx8Cr+kg4UYk0sK67MPcQowcGsJML7QEkmUIg3JbGyKrUoP76oNCe1+BBj
	MtCBE5mlRJPzgdGXVxJvaGxgbGhoaWhmamlqQJqwkjgv46knAUIC6YklqdmpqQWpRTBbmDg4
	pRoYEz7O+jTp02VnBfYOudwpAo/23maKOPvY3+PiF+NvTqvif32SPnkuvePX7AWq0zMsTy4+
	kBavzhx61qrz5Ic7mluDMhftXPh6zcwfT4PXsc4zaPYTav/2u7hRY+X9H9d7pt079i48j+H5
	qtX3uzgbZcOVfhfPeagQJP+n0Wfp6lObTlUosfXWLlFiKc5INNRiLipOBACs6/EotAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd3tKjKBBj87uSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxptVBxgLXgpWdE57xdrA
	uIWvi5GTQ0LAROLHmoUsELaYxIV769m6GLk4hASmM0rc6HzHCOF0MkncPXiFGaSKV0BLYnr/
	fnYQm0VAVaJlwwJGEJsNKL7/xQ02EFtUIExi5fQrLBD1ghI/Jt8Ds0UE5CSe3P4DNodZoFbi
	/tNjQDYHh7CAksTUq5wQYWuJlZO2MULY8hKb17xlnsDINwvJpFlIymYhKVvAyLyKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIziCnkntYFzZYHGIUYCDUYmHV/GXdKAQa2JZcWXuIUYJDmYl
	Ed4HSjKBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPjO68knhDYxMzI0sjM2MTc2Nj0oSV
	xHkZTz0JEBJITyxJzU5NLUgtgtnCxMEpBUwob3/Ptpj9tlhHO/tSml2NoPC6afp+/rZreb+e
	TF6n6XdS9uav7Al6FYZrHsbeLmZfw610oKmAqz9C5+BhLd5tQj8d5q/4b1bsGaH5/tiUXP3X
	ByrYOmr8pQWL1hm8lj3n6sXOzFvCLNd54zPrjgWBkmIKO2sPLuKQ31qmrBy1rGKi25k/e5RY
	ijMSDbWYi4oTAeSf+37kAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This pull-reqeust patchset is based on char-misc-next branch(char-misc.git).
Please pull extcon with following updates.

Best regards,
Chanwoo Choi

The following changes since commit 19d3243e797c2abc02a214d3cec9fefa5dc048ff:

   extcon: max77693: Remove unnecessary goto statement to improve 
readability (2013-02-13 08:35:44 -0800)

are available in the git repository at:

   git://git.kernel.org:/pub/scm/linux/kernel/git/chanwoo/extcon.git 
tags/extcon-for-3.9

for you to fetch changes up to af5eb1a13273447c5708cd5425696f3b6f79dd9b:

   extcon: max8997: Use workqueue to check cable state after completing 
boot of platform (2013-02-14 07:54:49 +0900)

----------------------------------------------------------------
extcon: updates for v3.9

This patchset add a few new feature of extcon-max8997
and fix minor issue of extcon-max8997/77693.

Update extcon-max8997 driver
- Consolidate duplicate code
- Set default uart/usb path for internal line of muic device
- Set default ADC debounce time
- Use wq to check cable state after certain delay
- Code clean to move defined constant to header file
- Make max8997_extcon_cable static

Update extcon-max77693 driver
- Make max77693_extcon_cable static

----------------------------------------------------------------
Chanwoo Choi (6):
       extcon: max8997: Move defined constant to header file
       extcon: max8997: Remove duplicate code related to set H/W line path
       extcon: max8997: Set default of ADC debounce time during 
initialization
       extcon: max8997: Consolidate duplicate code for checking ADC/CHG 
cable type
       extcon: max8997: Set default UART/USB path on probe
       extcon: max8997: Use workqueue to check cable state after 
completing boot of platform

Sachin Kamat (3):
       extcon: max8997: Make max8997_extcon_cable static
       extcon: max8997: Remove unreachable code
       extcon: max77693: Make max77693_extcon_cable static

  drivers/extcon/extcon-max77693.c    |   2 +-
  drivers/extcon/extcon-max8997.c     | 728 
++++++++++++++++++++++++------------
  include/linux/mfd/max8997-private.h |  64 ++++
  include/linux/mfd/max8997.h         |  25 +-
  4 files changed, 567 insertions(+), 252 deletions(-)
