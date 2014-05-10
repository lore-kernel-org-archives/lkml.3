Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaEJLXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 07:23:50 -0400
Received: from mout.gmx.net ([212.227.15.19]:49989 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaEJLXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 07:23:48 -0400
Date: Sat, 10 May 2014 15:22:38 +0200
From: Andreas Werner <wernerandy@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: khali@linux-fr.org, linux@roeck-us.net, andreas.werner@men.de
Subject: Question: hwmon: Adding addtitional sysfs entries
Message-ID: <20140510132238.GA28364@awedesk.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:1QcD67Yc5vurJYyR0YU67SiRyt7G1vu9MlcEd+67eQiCZCQkGYC
 hZTN7azy2Y9meCIFiuOS/T7a1ooGyj9YN0JvBeFMTSNLjUhsbr6r+UpQh7C5vFspunTgJtj
 T0pHnT3PKzHx4F/W9uY75FNLZWHA3Shz80f6xG66b/NM4HngXyE0QKcZwcnLZzgaHG+T0zc
 GKmzjfvafBjgwjOAT74ow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
i am currently working on an implemenation of my Board Management Controller (BMC).

This Controller is a MCR assembled on almost all of our Compact PCI or Compact PCI Serial
Cards as well as on some other CPU Boards.

The BMC includes LED´s, Watchdog, Voltage Monitoring and some other features.
I have already implemented an MFD driver, LED and Watchdog driver.

Currently i am working on the hwmon implemenation. This includes for the first step the
voltage monitoring.

The BMC has some other feature which are not supported by any of the subsystem.
 - Errorcounter (Board status)
 - Power Failure status
 - Operating ours
 - Do software reset, do cold reset
 - Set power modes
 - Backplate Geographical Address

These are all informations related to the Board where the BMC is assembled to.
I think all those features could be part of the hwmon implementation.

Is it possible to add "custom" sysfs entries in my hwmon driver to support all these features?
Does lm-sensor ingore those custom features or is it a problem for lm-sensors?

What is the normal way to add those features?

Regards
Andy
