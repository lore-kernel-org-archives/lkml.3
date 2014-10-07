Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaJGJuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:50:51 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:54128 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbaJGJus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:50:48 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 0/4] Input: pmic8xxx-keypad - add support for pm8941 keypad
Date: Tue,  7 Oct 2014 12:50:44 +0300
Message-Id: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

Following set of patches reorganize and add support for keypad
controller found in Qualcomm PMIC pm8941 chip, at least. 

Controllers found in pm8058 and pm8921, currently supported by driver,
seems to be similar to controller found in pm8941. Difference is 
register access, SSBI vs SPMI bus, registers offsets and bit definitions.

To be able to easily add support for new controller, driver have been 
converted to use struct regmap_field.

Regards,
Ivan

Ivan T. Ivanov (4):
  Input: pmic8xxx-keypad - remove unused register and bit definitions
  Input: pmic8xxx-keypad - use regmap_field for register access
  Input: pmic8xxx-keypad - add support keypad found in pm8941
  Input: pmic8xxx-keypad - update DT bindings documentation

 .../bindings/input/qcom,pm8xxx-keypad.txt          |  10 +-
 drivers/input/keyboard/pmic8xxx-keypad.c           | 299 +++++++++++++--------
 2 files changed, 188 insertions(+), 121 deletions(-)

-- 
1.9.1

