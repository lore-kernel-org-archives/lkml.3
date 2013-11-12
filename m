Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3KLOnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:43:13 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:51822 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab3KLOnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:43:10 -0500
Message-ID: <1384267377.5754.25.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: scripts: checkpatch.pl & Lindent (minor complaint)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Date: Tue, 12 Nov 2013 09:42:57 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111214-0928-0000-0000-000003526BE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

scripts/Lindent and scripts/checkpatch disagree whether the fields in a
statically initialized array should be blank separated.  

static struct ima_rule_entry default_rules[] = {
        {.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},

Lindent adds a blank before '.fsmagic', which checkpatch then complains
about (eg. commit 75834fc3).

thanks,

Mimi

