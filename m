Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab3FMKpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 06:45:52 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:48766 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab3FMKpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 06:45:51 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jun 2013 06:45:51 EDT
From: Reinhard Pfau <reinhard.pfau@gdsys.cc>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        Dirk Eibach <eibach@gdsys.de>, Dirk Eibach <dirk.eibach@gdsys.cc>
Subject: hwmon: add support for SMSC EMC2305/03/02/01 fan controller
Date: Thu, 13 Jun 2013 12:40:18 +0200
Message-Id: <1371120019-1744-1-git-send-email-reinhard.pfau@gdsys.cc>
X-Mailer: git-send-email 1.7.2.5
X-Df-Sender: UmVpbmhhcmQuUGZhdUBnZHN5cy5jYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to provide a driver for the SMSC EMC2305 fan controller which
we use in our devices in the hope that others might find it useful, too.                 

The driver also supports the SMSC EMC2303, EMC2302 and EMC2301 fan
controller chips which have same functionality and register layout, but
support less fans.

Testing is done only with EMC2305 fan controller (since this is the chip we
use; support for the other chips was included by using data sheets only) on
a PowerPC platform. Driver was tested as module and builtin.

The patch also adds me to the MAINTAINERS for this driver.

Greetings,
Reinhard Pfau
